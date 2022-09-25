RSpecTwirp
======
![Gem](https://img.shields.io/gem/dt/rspec-twirp?style=plastic)
[![codecov](https://codecov.io/gh/dpep/rspec-twirp/branch/main/graph/badge.svg)](https://codecov.io/gh/dpep/rspec-twirp)

RSpec matches for Twirp.


```ruby
require "rspec/twirp"

it { is_expected.to be_a_twirp_request }
it { is_expected.to be_a_twirp_request(name: /^Bo/ }

it { is_expected.to be_a_twirp_response }
it { is_expected.to be_a_twirp_response(message: "Hi Bob") }

it { is_expected.to be_a_twirp_error }
it { is_expected.to be_a_twirp_error(:internal) }

it { is_expected.to be_a_twirp_client_response.with_error }
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
