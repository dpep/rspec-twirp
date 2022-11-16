RSpec::Matchers.define :be_a_twirp_response do |**attrs|
  chain :with_error do |*matchers, **meta_matchers|
    # code, msg, meta
    @with_error = [ matchers, meta_matchers ]
  end

  match do |actual|
    @fail_msg = "Expected a Twirp::ClientResp, found #{actual}"
    return false unless actual.is_a?(Twirp::ClientResp)

    if @with_error
      unless attrs.empty?
        raise ArgumentError, "match data attributes or error, but not both"
      end

      @fail_msg = "Expected #{actual} to have an error, but found none"
      return false unless actual.error

      matchers, meta_matchers = @with_error
      expect(actual.error).to be_a_twirp_error(*matchers, **meta_matchers)
    else
      @fail_msg = "Expected #{actual} to have data, but found none"
      return false unless actual.data

      expect(actual.data).to be_a_twirp_message(**attrs)
    end
  rescue RSpec::Expectations::ExpectationNotMetError => err
    @fail_msg = err.message
    false
  end

  description do
    "a Twirp response"
  end

  failure_message { @fail_msg }
end

RSpec::Matchers.alias_matcher :a_twirp_response, :be_a_twirp_response
