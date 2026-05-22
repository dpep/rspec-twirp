require_relative "lib/rspec/twirp/version"

Gem::Specification.new do |s|
  s.authors     = ["Daniel Pepper"]
  s.description = "Twirp RSpec matchers"
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = "https://github.com/dpep/rspec-twirp"
  s.license     = "MIT"
  s.name        = "rspec-twirp"
  s.summary     = "RSpec::Twirp"
  s.version     = RSpec::Twirp::VERSION

  s.required_ruby_version = ">= 3.2"

  s.add_dependency "rspec-expectations", ">= 3"
  s.add_dependency "rspec-protobuf", ">= 0.3"
  s.add_dependency "twirp", ">= 1.11"

  s.add_development_dependency "debug"
  s.add_development_dependency "rspec", ">= 3"
  s.add_development_dependency "simplecov"
end
