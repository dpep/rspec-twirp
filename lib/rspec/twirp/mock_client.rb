# mock_twirp_client(Twirp::Client, { rpc => response } )

module RSpec
  module Twirp
    def mock_client(client, **responses)
      unless client.is_a?(Class) && client < ::Twirp::Client
        raise ArgumentError, "Expected Twirp::Client, found: #{client.class}"
      end

      rpcs = client.rpcs.values

      client_instance = client.new(mock_connection)

      unless responses.empty?
        # validate input
        responses.transform_keys! do |rpc_name|
          rpc_info = rpcs.find do |x|
            x[:rpc_method] == rpc_name || x[:ruby_method] == rpc_name
          end

          unless rpc_info
            raise ArgumentError, "invalid rpc method: #{rpc_name}"
          end

          rpc_info[:rpc_method]
        end

        # repackage responses
        client_responses = {}
        responses.each do |rpc_method, response|
          if response.is_a?(Hash)
            response = client.rpcs[rpc_method.to_s][:output_class].new(**response)
          end

          client_responses[rpc_method] = RSpec::Twirp.generate_client_response(response)
        end

        # mock
        rpcs.each do |info|
          response = client_responses[info[:rpc_method]]

          if response
            allow(client_instance).to receive(:rpc).with(
              info[:rpc_method],
              any_args,
            ).and_return(response)
          else
            allow(client_instance).to receive(:rpc).with(
              info[:rpc_method],
              any_args,
            ).and_raise(::RSpec::Mocks::MockExpectationError)
          end
        end
      end

      client_instance
    end
  end
end
