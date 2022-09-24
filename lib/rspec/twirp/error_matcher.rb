RSpec::Matchers.define :be_a_twirp_error do |*matchers, **meta_matcher|
  match do |actual|
    return false unless actual.is_a?(Twirp::Error)

    matchers.each do |matcher|
      case matcher
      when Symbol
        # match code
        @cur_match = { code: matcher }

        unless Twirp::Error.valid_code?(matcher)
          raise ArgumentError, "invalid error code: #{matcher.inspect}"
        end

        return false unless actual.code == matcher
      else
        # match msg

        @cur_match = { msg: matcher }
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

      return false unless values_match?(meta_matcher, actual.meta)
    end

    true
  end

  description do
    if @cur_match
      key, value = @cur_match.first
      "a Twirp::Error(#{key}: #{value.inspect})"
    else
      "a Twirp::Error"
    end
  end
end

RSpec::Matchers.alias_matcher :a_twirp_error, :be_a_twirp_error
