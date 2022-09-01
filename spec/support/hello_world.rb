require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "HelloRequest" do
    optional :name, :string, 1
    optional :count, :int32, 2
  end

  add_message "HelloResponse" do
    optional :message, :string, 1
  end

  add_message "GoodbyeRequest" do
    optional :name, :string, 1
  end
end

HelloRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("HelloRequest").msgclass
HelloResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("HelloResponse").msgclass

GoodbyeRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("GoodbyeRequest").msgclass
