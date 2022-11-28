require_relative "lib/rspec/twirp/version"
package = RSpec::Twirp

Gem::Specification.new do |s|
  s.authors     = ["Daniel Pepper"]
  s.description = "Twirp RSpec matchers"
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = "https://github.com/dpep/rspec-twirp"
  s.license     = "MIT"
  s.name        = File.basename(__FILE__).split(".")[0]
  s.summary     = package.to_s
  s.version     = package.const_get "VERSION"

  s.add_dependency "google-protobuf", ">= 3"
  s.add_dependency "rspec", ">= 3"
  s.add_dependency "rspec-protobuf", ">= 0.2"
  s.add_dependency "twirp", ">= 1"

  s.add_development_dependency "byebug"
  s.add_development_dependency "codecov"
  s.add_development_dependency "simplecov"
end
