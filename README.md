RSpec::Twirp
======
![Gem](https://img.shields.io/gem/dt/rspec-twirp?style=plastic)
[![codecov](https://codecov.io/gh/dpep/rspec-twirp/branch/main/graph/badge.svg)](https://codecov.io/gh/dpep/rspec-twirp)

Twirp RSpec matchers.


```ruby
require "rspec/twirp"

it "matches Twirp responses" do
  is_expected.to be_a_twirp_response
  is_expected.to be_a_twirp_response(count: 3)
  is_expected.to be_a_twirp_response.with_error(:not_found)
end

it "matches Twirp messages" do
  is_expected.to be_a_twirp_message
  is_expected.to be_a_twirp_message(MyRequest)
  is_expected.to be_a_twirp_message(name: /^B/)
end

it "matches Twirp errors" do
  is_expected.to be_a_twirp_error
  is_expected.to be_a_twirp_error(:internal)
end
```

To stub Twirp requests, see [webmock-twirp](https://github.com/dpep/webmock-twirp).


----
## Contributing

Yes please  :)

1. Fork it
1. Create your feature branch (`git checkout -b my-feature`)
1. Ensure the tests pass (`bundle exec rspec`)
1. Commit your changes (`git commit -am 'awesome new feature'`)
1. Push your branch (`git push origin my-feature`)
1. Create a Pull Request
