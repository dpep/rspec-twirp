require "rspec/expectations"

require "rspec/twirp/client_response_matcher"
require "rspec/twirp/error_matcher"
require "rspec/twirp/request_matcher"
require "rspec/twirp/response_matcher"

module RSpec
  module Twirp
    extend self

    def validate_types(attrs, klass)
      # sanity check type and names of attrs by constructing an actual
      # proto object
      discrete_attrs = attrs.transform_values do |attr|
        case attr
        when Regexp
          attr.inspect
        when Range
          attr.first
        when RSpec::Matchers::BuiltIn::BaseMatcher
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
end
