require "rspec/twirp/mock_connection"

module RSpec
  module Twirp
    module Helpers
      def mock_twirp_connection(...)
        RSpec::Twirp.mock_connection(...)
      end
    end
  end
end
