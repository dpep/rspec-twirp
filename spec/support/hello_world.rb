require_relative 'hello_world/service_pb'

class HelloWorldService < Twirp::Service
  service "HelloWorld"
  rpc :Hello, HelloRequest, HelloResponse, :ruby_method => :hello
end

class HelloWorldClient < Twirp::Client
  client_for HelloWorldService
end

class HelloWorldHandler
  def hello(req, env)
    return Twirp::Error.not_found("name required") if req.name.empty?
    return Twirp::Error.invalid_argument("count must be >= 0") if req.count < 0

    count = [ 1, req.count ].max
    msg = ["Hello"] * (count - 1) + ["Hello #{req.name}"]

    { message: msg }
  end
end


class GoodbyeService < Twirp::Service
  service "Goodbye"
  rpc :Bye, GoodbyeRequest, GoodbyeResponse, :ruby_method => :bye
  rpc :Goodbye, GoodbyeRequest, GoodbyeResponse, :ruby_method => :goodbye
end

class GoodbyeClient < Twirp::Client
  client_for GoodbyeService
end

class GoodbyeHandler
  def bye(req, env)
    { message: "bye", name: req.name }.compact
  end

  def goodbye(...)
    bye(...)
  end
end
