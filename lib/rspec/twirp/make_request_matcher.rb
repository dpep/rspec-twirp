# expect {
#   do_the_thing
# }.to make_twirp_request(client | service | rpc_method).with(request | attrs)

RSpec::Matchers.define :make_twirp_request do |*matchers|
  chain :with do |request = nil, **attrs|
    unless !!request ^ attrs.any?
      raise ArgumentError, "specify request or attributes, but not both"
    end

    @input_matcher = if request
      if request.is_a?(Google::Protobuf::MessageExts)
        defaults = request.class.new.to_h
        hash_form = request.to_h.reject {|k,v| v == defaults[k] }

        ->(input) do
          if input.is_a?(Google::Protobuf::MessageExts)
            values_match?(request, input)
          else
            values_match?(include(**hash_form), input.to_h)
          end
        end
      elsif request.is_a?(Class) && request < Google::Protobuf::MessageExts
        ->(input) { values_match?(be_a(request), input) }
      else
        raise TypeError, "Expected a request of type `Google::Protobuf::MessageExts`, found #{request.class}"
      end
    elsif attrs.any?
      ->(input) { values_match?(include(**attrs), input.to_h) }
    end
  end

  chain(:and_call_original) { @and_call_original = true }

  supports_block_expectations

  match do |client_or_block|
    @input_matcher ||= ->(*){ true }

    if client_or_block.is_a? Proc
      RSpec::Mocks.with_temporary_scope do
        match_block_request(client_or_block, matchers)
      end
    elsif client_or_block.is_a?(Twirp::Client)
      match_client_request(client_or_block, matchers)
    else
      raise ArgumentError, "Expected Twirp::Client or block, found: #{client_or_block}"
    end
  end

  def match_block_request(block, matchers)
    expected_client = be_a(Twirp::Client)
    expected_service = anything
    expected_rpc_name = anything

    matchers.each do |matcher|
      case matcher
      when Twirp::Client
        expected_client = be(matcher)
      when Class
        if matcher <= Twirp::Client
          expected_client = be_a(matcher)
        elsif matcher <= Twirp::Service
          expected_service = matcher.service_full_name
        else
          raise NotImplementedError
        end
      when String
        expected_rpc_name = be(matcher.to_sym)
      when Symbol
        expected_rpc_name = be(matcher)
      when Regexp
        expected_rpc_name = matcher
      end
    end

    @twirp_request_made = false

    # stub pre-existing client instances
    ObjectSpace.each_object(Twirp::Client) do |client|
      if expected_client === client && (expected_service === client.class.service_full_name)
        stub_client(client, expected_rpc_name)
      end
    end

    # stub future client instances
    ObjectSpace.each_object(Twirp::Client.singleton_class).select do |obj|
      obj < Twirp::Client && obj != Twirp::ClientJSON
    end.each do |client_type|
      next unless client_type.name && expected_service === client_type.service_full_name

      allow(client_type).to receive(:new).and_wrap_original do |orig, *args, **kwargs|
        orig.call(*args, **kwargs).tap do |client|
          if expected_client === client
            stub_client(client, expected_rpc_name)
          end
        end
      end
    end

    block.call

    @twirp_request_made
  end

  def stub_client(client, rpc_matcher)
    allow(client).to receive(:rpc).and_wrap_original do |orig, rpc_name, input, req_opts|
      if values_match?(rpc_matcher, rpc_name) && @input_matcher.call(input)
        @twirp_request_made = true
      end

      orig.call(rpc_name, input, req_opts) if @and_call_original
    end
  end

  def match_client_request(client)
    rpc_name = matchers.find do |matcher|
      matcher.is_a?(String)
    end

    if rpc_name
      rpc_info = client.class.rpcs.values.find do |x|
        x[:rpc_method] == rpc_name || x[:ruby_method] == rpc_name
      end

      raise ArgumentError, "invalid rpc method: #{rpc_name}" unless rpc_info

      input = case @request
      when Google::Protobuf::MessageExts
        unless @request.class == rpc_info[:input_class]
          raise TypeError, "Expected a request of type `#{rpc_info[:input_class]}`, found #{@request.class}"
        end

        defaults = @request.class.new.to_h
        hash_form = @request.to_h.reject {|k,v| v == defaults[k] }

        eq(@request) | include(**hash_form)
      when Hash
        a_twirp_message(rpc_info[:input_class], **@request) | include(**@request)
      else
        be_a(rpc_info[:input_class]) | be_a(Hash)
      end

      msg = "Expected #{client} to make a twirp request to #{rpc_name}"
      expect(client).to receive(:rpc).with(rpc_info[:rpc_method], input, @request_opts), msg
    else
      # match any outgoing request
      msg = "Expected #{client} to make a twirp request"
      expect(client).to receive(:rpc), msg
    end
  end

  description do
    "make a Twirp request"
  end

  failure_message { @fail_msg || super() }
end

RSpec::Matchers.alias_matcher :make_a_twirp_request, :make_twirp_request
