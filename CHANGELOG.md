## Unreleased
- Fix nested matchers on google-protobuf 4, e.g. `be_a_twirp_message(request: include(count: 0))`: protobuf 4's `to_h` drops default-valued fields, so these silently failed. Requires rspec-protobuf >= 0.4.
- Requires Ruby >= 3.3 (rspec-protobuf 0.4 does). Ruby 3.2 users stay on rspec-twirp 0.4.1.

###  v0.4.1  (2023-03-28)
- bump gems
- simplify (#17)
- codecov upgrade

###  v0.4.0  (2023-02-12)
- support for twirp 1.10

###  v0.3.1  (2022-12-15)
- simplify dependencies
- action permissions
- dependabot automation
- lockfile
- builds

###  v0.3.0  (2022-11-16)
- diffable error matching
- extract request stubbing

###  v0.2.0  (2022-10-06)
- ruby 3 fixes
- mock_client
- improved make_request spec
- upgrade mock connection
- inline request matcher
- request matcher and_return
- make request matcher
- mock_twirp_connection
- twirp message matcher simplification

###  v0.1.0  (2022-09-24)
- Update README.md
- client response matcher
- improved fail messages
- response matcher
- error matcher
- improve regex match
- be_a_twirp_request

###  v0.0.1  (2022-05-24)
- init

