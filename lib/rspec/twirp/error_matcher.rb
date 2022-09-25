RSpec::Matchers.define :be_a_twirp_error do |*matchers, **meta_matcher|
  match do |actual|
    @fail_msg = "Expected #{actual} to be a Twirp::Error, found #{actual.class}"
    return false unless actual.is_a?(Twirp::Error)

    matchers.each do |matcher|
      case matcher
      when Symbol
        # match code

        unless Twirp::Error.valid_code?(matcher)
          raise ArgumentError, "invalid error code: #{matcher.inspect}"
        end

        @fail_msg = "Expected #{actual} to have code: #{matcher.inspect}, found #{actual.code}"
        return false unless actual.code == matcher
      else
        # match msg

        @fail_msg = "Expected #{actual} to have msg: #{matcher.inspect}, found #{actual.msg}"
        return false unless values_match?(matcher, actual.msg)
      end
    end

    # match meta
    unless meta_matcher.empty?
      @cur_match = { meta: meta_matcher }

      # sanity check...values must be Strings or Regexp
      discrete_attrs = meta_matcher.transform_values do |attr|
        attr.is_a?(Regexp) ? attr.inspect : attr
      end
      actual.send(:validate_meta, discrete_attrs)


      @fail_msg = "Expected #{actual} to have meta: #{meta_matcher.inspect}, found #{actual.meta}"
      return false unless values_match?(meta_matcher, actual.meta)
    end

    true
  end

  description do
    "a Twirp::Error"
  end

  failure_message { @fail_msg }
end

RSpec::Matchers.alias_matcher :a_twirp_error, :be_a_twirp_error
