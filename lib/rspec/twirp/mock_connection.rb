# GoodbyeClient.new(mock_twirp_connection)

module RSpec
  module Twirp
    extend self

    def mock_connection(response = nil, **attrs)
      unless response.nil? || attrs.empty?
        raise ArgumentError, "can not specify both response and attrs"
      end

      if block_given? && (response || attrs.any?)
        raise ArgumentError, "can not specify both block and args"
      end

      Faraday.new do |conn|
        conn.adapter :test do |stub|
          stub.post(/.*/) do |env|
            response = yield(env) if block_given?
            if response.is_a?(Hash)
              attrs = response
              response = nil
            end

            if response.nil?
              # create default response

              # determine which client would make this rpc call
              service_full_name, rpc_method = env.url.path.split("/").last(2)
              client = ObjectSpace.each_object(::Twirp::Client.singleton_class).find do |client|
                next unless client.name

                client.service_full_name == service_full_name && client.rpcs.key?(rpc_method)
              end

              unless client
                raise TypeError, "could not determine Twirp::Client for: #{env.url.path}"
              end

              response = client.rpcs[rpc_method][:output_class].new(**attrs)
            end

            res = RSpec::Twirp.generate_client_response(response)

            if res.data
              status = 200
              headers = { "Content-Type" => ::Twirp::Encoding::PROTO }
              body = res.data.to_proto
            else
              status = ::Twirp::ERROR_CODES_TO_HTTP_STATUS[res.error.code]
              headers = { "Content-Type" => ::Twirp::Encoding::JSON } # errors are always JSON
              body = ::Twirp::Encoding.encode_json(res.error.to_h)
            end

            [ status, headers, body ]
          end
        end
      end
    end
  end
end
