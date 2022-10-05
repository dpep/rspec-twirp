require "rspec/twirp/mock_client"
require "rspec/twirp/mock_connection"

module RSpec
  module Twirp
    module Helpers
      def mock_twirp_connection(...)
        RSpec::Twirp.mock_connection(...)
      end

      def mock_twirp_client(...)
        RSpec::Twirp.mock_client(...)
      end
    end
  end
end
