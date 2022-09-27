pool = Google::Protobuf::DescriptorPool.new

pool.build do
  add_message "HelloRequest" do
    optional :name, :string, 1
    optional :count, :int32, 2
  end

  add_message "HelloResponse" do
    repeated :message, :string, 1
  end

  add_message "GoodbyeRequest" do
    optional :name, :string, 1
  end

  add_message "GoodbyeResponse" do
    optional :message, :string, 1
    optional :name, :string, 2
  end
end

HelloRequest = pool.lookup("HelloRequest").msgclass
HelloResponse = pool.lookup("HelloResponse").msgclass
GoodbyeRequest = pool.lookup("GoodbyeRequest").msgclass
GoodbyeResponse = pool.lookup("GoodbyeResponse").msgclass

# Google::Protobuf::DescriptorPool.generated_pool.build do
# HelloRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("HelloRequest").msgclass
# HelloResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("HelloResponse").msgclass
# GoodbyeRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("GoodbyeRequest").msgclass

class HelloWorldService < Twirp::Service
  service "HelloWorld"
  rpc :Hello, HelloRequest, HelloResponse, :ruby_method => :hello
  rpc :Goodbye, GoodbyeRequest, GoodbyeResponse, :ruby_method => :goodbye
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

  def goodbye(req, env)
    { message: "bye", name: req.name }.compact
  end
end
