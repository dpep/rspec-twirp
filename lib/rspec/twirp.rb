require "google/protobuf"
require "rspec/expectations"
require "twirp"

require "rspec/twirp/helpers"
require "rspec/twirp/make_request_matcher"
require "rspec/twirp/error_matcher"
require "rspec/twirp/message_matcher"
require "rspec/twirp/response_matcher"

RSpec.configure do |config|
  config.include(RSpec::Twirp::Helpers)
end if RSpec.respond_to?(:configure)
