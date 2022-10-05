require "google/protobuf"
require "rspec"
require "twirp"

require "rspec/twirp/helpers"
require "rspec/twirp/make_request_matcher"
require "rspec/twirp/error_matcher"
require "rspec/twirp/message_matcher"
require "rspec/twirp/response_matcher"

module RSpec
  module Twirp
    extend RSpec::Mocks::ExampleMethods

    # private

    def generate_client_response(arg)
      res = case arg
      when Google::Protobuf::MessageExts, ::Twirp::Error
        arg
      when Class
        if arg < Google::Protobuf::MessageExts
          arg.new
        else
          raise TypeError, "Expected type `Google::Protobuf::MessageExts`, found: #{arg}"
        end
      when Symbol
        if ::Twirp::Error.valid_code?(arg)
          ::Twirp::Error.new(arg, arg)
        else
          raise ArgumentError, "invalid error code: #{arg}"
        end
      when Integer
        if code = ::Twirp::ERROR_CODES_TO_HTTP_STATUS.index(arg)
          ::Twirp::Error.new(code, code)
        else
          raise ArgumentError, "invalid error code: #{arg}"
        end
      else
        raise NotImplementedError
      end

      if res.is_a?(Google::Protobuf::MessageExts)
        ::Twirp::ClientResp.new(res, nil)
      else
        ::Twirp::ClientResp.new(nil, res)
      end
    end
  end
end

RSpec.configure do |config|
  config.include(RSpec::Twirp::Helpers)
end
