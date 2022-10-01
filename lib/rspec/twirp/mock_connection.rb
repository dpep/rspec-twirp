def mock_twirp_connection(path, response = nil, **attrs)
  unless response.nil? || attrs.empty?
    raise ArgumentError, "can not specify both response and attrs"
  end

  if block_given? && (response || attrs.any?)
    raise ArgumentError, "can not specify both block and args"
  end

  # determine which client would make this rpc call
  service_full_name, rpc_method = path.split("/").last(2)
  client = ObjectSpace.each_object(Twirp::Client.singleton_class).find do |client|
    next unless client.name

    client.service_full_name == service_full_name && client.rpcs.key?(rpc_method)
  end

  unless client
    raise ArgumentError, "could not determine Twirp::Client for: #{path}"
  end

  Faraday.new do |conn|
    conn.adapter :test do |stub|
      stub.post(path) do |env|
        response = yield(env) if block_given?
        if response.is_a?(Hash)
          attrs = response
          response = nil
        end

        if response.nil?
          # create default response
          response = client.rpcs[rpc_method][:output_class].new(**attrs)
        end

        res = case response
        when Google::Protobuf::MessageExts
          response.to_proto
        when Twirp::Error
          response
        when Class
          if response < Google::Protobuf::MessageExts
            response.new.to_proto
          else
            raise NotImplementedError
          end
        when Symbol
          if Twirp::Error.valid_code?(response)
            Twirp::Error.new(response, response)
          else
            raise ArgumentError, "invalid error code: #{response}"
          end
        when Integer
          if code = Twirp::ERROR_CODES_TO_HTTP_STATUS.index(response)
            Twirp::Error.new(code, code)
          else
            raise ArgumentError, "invalid error code: #{response}"
          end
        else
          raise NotImplementedError
        end

        if res.is_a?(Twirp::Error)
          status = Twirp::ERROR_CODES_TO_HTTP_STATUS[res.code]
          headers = { "Content-Type" => Twirp::Encoding::JSON } # errors are always JSON
          body = Twirp::Encoding.encode_json(res.to_h)
        else
          status = 200
          headers = { "Content-Type" => Twirp::Encoding::PROTO }
          body = res
        end

        [ status, headers, body ]
      end
    end
  end
end
