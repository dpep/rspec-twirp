RSpec::Twirp
======
![Gem](https://img.shields.io/gem/dt/rspec-twirp?style=plastic)
[![codecov](https://codecov.io/gh/dpep/rspec-twirp/branch/main/graph/badge.svg)](https://codecov.io/gh/dpep/rspec-twirp)

RSpec matchers for Twirp.


```ruby
require "rspec/twirp"

it "can match Twirp messages" do
  is_expected.to be_a_twirp_message
  is_expected.to be_a_twirp_message(MyRequest)
  is_expected.to be_a_twirp_message(name: /^B/)
end

it "can match Twirp errors" do
  is_expected.to be_a_twirp_error
  is_expected.to be_a_twirp_error(:internal)
end

it "can check Twirp responses" do
  is_expected.to be_a_twirp_response
  is_expected.to be_a_twirp_response(count: 3)
  is_expected.to be_a_twirp_response.with_error(:not_found)
end

it "can intercept Twirp calls"
  expect { ... }.to make_twirp_call
  
  expect { ... }.to make_twirp_call(MyService).with(param: "abc").and_return(MyResponse)
end

it "can mock client connections" do
  client = MyClient.new(mock_twirp_connection)
  expect(client.hello).to be_a_twirp_response(HelloResponse)
  
  # or specify attributes
  client = MyClient.new(mock_twirp_connection(name: "Daniel"))
  expect(client.hello).to be_a_twirp_response(HelloResponse, name: "Daniel")
end

it "can mock clients" do 
  client = mock_twirp_client(HelloClient)
  expect(client.hello).to be_a_twirp_response(HelloResponse)
  
  # or specify attributes
  client = mock_twirp_client(HelloClient, name: "Shira")
  expect(client.hello).to be_a_twirp_response(name: "Shira")
end
```


----
## Contributing

Yes please  :)

1. Fork it
1. Create your feature branch (`git checkout -b my-feature`)
1. Ensure the tests pass (`bundle exec rspec`)
1. Commit your changes (`git commit -am 'awesome new feature'`)
1. Push your branch (`git push origin my-feature`)
1. Create a Pull Request
