RSpec::Matchers.define :be_a_twirp_response do |type = nil, **attrs|
  match do |actual|
    # ensure type is a valid twirp response type
    if type && !(type < Google::Protobuf::MessageExts)
      raise ArgumentError, "Expected Twirp response, found: #{type}"
    end

    # sanity check response type
    unless actual.class.is_a?(Class)
      raise ArgumentError, "Expected Twirp response, found: #{actual.class}"
    end

    return false unless actual.is_a?(Google::Protobuf::MessageExts)

    # match expected response type
    return false if type && actual.class != type

    return true if attrs.empty?

    RSpec::Twirp.validate_types(attrs, actual.class)

    # match attributes which are present
    values_match?(attrs, actual.to_h.slice(*attrs.keys))
  end

  description do
    type ? "a #{type} Twirp response" : "a Twirp response"
  end
end

RSpec::Matchers.alias_matcher :a_twirp_response, :be_a_twirp_response
