RSpec::Matchers.define :be_a_twirp_error do |*matchers, **meta_matcher|
  match do |actual|
    @fail_msg = "Expected `#{actual}` to be a Twirp::Error, found: #{actual.class}"
    return false unless actual.is_a?(Twirp::Error)

    @expected = {}
    @actual = {}

    matched = matchers.all? do |matcher|
      case matcher
      when Symbol
        # match code
        @expected[:code] = matcher
        @actual[:code] = actual.code

        unless Twirp::Error.valid_code?(matcher)
          raise ArgumentError, "invalid error code: #{matcher.inspect}"
        end

        @fail_msg = "Expected #{actual} to have code `#{matcher.inspect}`, found: #{actual.code.inspect}"
        actual.code == matcher
      when Integer
        # match http status code

        if code = Twirp::ERROR_CODES_TO_HTTP_STATUS.key(matcher)
          @expected[:code] = code
          @actual[:code] = actual.code

          actual_status = Twirp::ERROR_CODES_TO_HTTP_STATUS[actual.code]

          @fail_msg = "Expected #{actual} to have status #{matcher} / #{code.inspect}, found: #{actual_status} / #{actual.code.inspect}"
          actual.code == code
        else
          raise ArgumentError, "invalid error status code: #{matcher}"
        end
      when Twirp::Error
        # match instance
        @expected = matcher.to_h
        @actual = actual.to_h

        @fail_msg = "Expected #{actual} to equal #{matcher}"
        values_match?(matcher.to_h, actual.to_h)
      else
        # match msg
        @expected[:msg] = matcher
        @actual[:msg] = actual.msg

        @fail_msg = "Expected #{actual} to have msg #{matcher.inspect}, found: #{actual.msg.inspect}"
        values_match?(matcher, actual.msg)
      end
    end

    # match meta
    unless meta_matcher.empty?
      @expected[:meta] = meta_matcher
      @actual[:meta] = actual.meta

      # sanity check...values must be Strings or Regexp
      discrete_attrs = meta_matcher.transform_values do |attr|
        attr.is_a?(Regexp) ? attr.inspect : attr
      end
      actual.send(:validate_meta, discrete_attrs)

      @fail_msg = "Expected #{actual} to have meta: #{meta_matcher.inspect}, found #{actual.meta}"
      matched &= values_match?(meta_matcher, actual.meta)
    end

    matched
  end

  description do
    "a Twirp::Error"
  end

  failure_message { @fail_msg }

  diffable

  def expected
    @expected
  end
end

RSpec::Matchers.alias_matcher :a_twirp_error, :be_a_twirp_error
