require "rspec/expectations"

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

    # match request type
    return false if type && actual.class != type

    return true unless @attrs

    # ensure attributes are valid for request
    invalid_attrs = @attrs.keys.map(&:to_sym) - actual.to_h.keys
    unless invalid_attrs.empty?
      raise ArgumentError, "Unknown field name: #{invalid_attrs.join(',')}"
    end

    # type check
    begin
      discrete_attrs = @attrs.transform_values do |attr|
        case attr
        when Regexp
          "Regexp"
        when Range
          attr.first
        else
          attr
        end
      end

      actual.class.new(**discrete_attrs)
    rescue Google::Protobuf::TypeError => e
      raise TypeError, e.message
    end

    # match attributes
    values_match?(@attrs, actual.to_h)
  end

  description do
    type ? "a #{type} Twirp request" : "a Twirp request"
  end
end

RSpec::Matchers.alias_matcher :a_twirp_request, :be_a_twirp_request
