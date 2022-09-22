require "google/protobuf"
require "twirp"

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
end

HelloRequest = pool.lookup("HelloRequest").msgclass
HelloResponse = pool.lookup("HelloResponse").msgclass
GoodbyeRequest = pool.lookup("GoodbyeRequest").msgclass

# Google::Protobuf::DescriptorPool.generated_pool.build do
# HelloRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("HelloRequest").msgclass
# HelloResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("HelloResponse").msgclass
# GoodbyeRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("GoodbyeRequest").msgclass

class HelloWorldService < Twirp::Service
  service "HelloWorld"
  rpc :Hello, HelloRequest, HelloResponse, :ruby_method => :hello
end

class HelloWorldClient < Twirp::Client
  client_for HelloWorldService
end

class HelloWorldHandler
  def hello(req, env)
    if req.name.empty?
      return Twirp::Error.invalid_argument("name is mandatory")
    end

    count = [ 1, req.count ].max
    msg = ["Hello"] * (count - 1) + ["Hello #{req.name}"]

    { message: msg }
  end
end
