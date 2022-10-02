require "google/protobuf"
require "rspec/expectations"
require "twirp"

require "rspec/twirp/make_request_matcher"
require "rspec/twirp/mock_connection"
require "rspec/twirp/error_matcher"
require "rspec/twirp/message_matcher"
require "rspec/twirp/response_matcher"

module RSpec
  module Twirp
    module Helpers
      def mock_twirp_connection(...)
        RSpec::Twirp.mock_connection(...)
      end
    end
  end
end

RSpec.configure do |config|
  config.include(RSpec::Twirp::Helpers)
end
