require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "example.HelloRequest" do
    optional :name, :string, 1
  end
  add_message "example.HelloResponse" do
    optional :message, :string, 1
  end
end

module Example
  HelloRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("example.HelloRequest").msgclass
  HelloResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("example.HelloResponse").msgclass
end

require "twirp"
