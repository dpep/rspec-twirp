RSpec::Matchers.define :be_a_twirp_message do |type = nil, **attrs|
  match do |actual|
    # ensure type is a valid twirp message type
    if type && !(type < Google::Protobuf::MessageExts)
      raise TypeError, "Expected `type` to be a Google::Protobuf::MessageExts, found: #{type}"
    end

    @fail_msg = "Expected a Twirp message, found #{actual}"
    return false unless actual.is_a?(Google::Protobuf::MessageExts)

    # match expected message type
    @fail_msg = "Expected a Twirp message of type #{type}, found #{actual.class}"
    return false if type && actual.class != type

    return true if attrs.empty?

    # sanity check inputs
    validate_types(attrs, actual.class)

    # match attributes which are present
    attrs.each do |attr_name, expected_attr|
      actual_attr = actual.send(attr_name)

      @fail_msg = "Expected #{actual} to have #{attr_name}: #{expected_attr.inspect}, found #{actual_attr}"
      return false unless values_match?(expected_attr, actual_attr)
    end

    true
  end

  description do
    type ? "a #{type} Twirp message" : "a Twirp message"
  end

  failure_message { @fail_msg }

  private

  def validate_types(attrs, klass)
    # check names and types of attrs by constructing an actual proto object
    discrete_attrs = attrs.transform_values do |attr|
      case attr
      when Regexp
        attr.inspect
      when Range
        attr.first
      when RSpec::Matchers::BuiltIn::BaseMatcher
        # no good substitute, so skip attr and hope for the best
        nil
      else
        attr
      end
    end.compact

    klass.new(**discrete_attrs)
  rescue Google::Protobuf::TypeError => e
    raise TypeError, e.message
  end
end

RSpec::Matchers.alias_matcher :a_twirp_message, :be_a_twirp_message
