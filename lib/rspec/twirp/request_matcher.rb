RSpec::Matchers.define :be_a_twirp_request do |type = nil|
  chain :with do |**attrs|
    @attrs = attrs
  end

  match do |actual|
    # ensure type is a valid twirp request type
    if type && !(type < Google::Protobuf::MessageExts)
      raise ArgumentError, "Expected Twirp request, found: #{type}"
    end

    return false unless actual.is_a?(Google::Protobuf::MessageExts)

    # match expected request type
    return false if type && actual.class != type

    return true unless @attrs

    RSpec::Twirp.validate_types(@attrs, actual.class)

    # match attributes which are present
    values_match?(@attrs, actual.to_h.slice(*@attrs.keys))
  end

  description do
    type ? "a #{type} Twirp request" : "a Twirp request"
  end
end

RSpec::Matchers.alias_matcher :a_twirp_request, :be_a_twirp_request
