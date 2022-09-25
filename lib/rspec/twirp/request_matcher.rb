RSpec::Matchers.define :be_a_twirp_request do |type = nil, **attrs|
  match do |actual|
    # ensure type is a valid twirp request type
    if type && !(type < Google::Protobuf::MessageExts)
      raise ArgumentError, "Expected `type` to be a Twirp request, found: #{type}"
    end

    @fail_msg = "Expected a Twirp request, found #{actual}"
    return false unless actual.is_a?(Google::Protobuf::MessageExts)

    # match expected request type
    @fail_msg = "Expected a Twirp request of type #{type}, found #{actual.class}"
    return false if type && actual.class != type

    return true if attrs.empty?

    RSpec::Twirp.validate_types(attrs, actual.class)

    # match attributes which are present
    attrs.each do |attr_name, expected_attr|
      actual_attr = actual.send(attr_name)

      @fail_msg = "Expected #{actual} to have #{attr_name}: #{expected_attr.inspect}, found #{actual_attr}"
      return false unless values_match?(expected_attr, actual_attr)
    end

    true
  end

  description do
    type ? "a #{type} Twirp request" : "a Twirp request"
  end

  failure_message { @fail_msg }
end

RSpec::Matchers.alias_matcher :a_twirp_request, :be_a_twirp_request
