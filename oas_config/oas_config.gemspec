$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "oas_config/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "oas_config"
  s.version     = OasConfig::VERSION
  s.authors     = ["Josh Sullivan"]
  s.email       = ["jsullivan@silverchalice.com"]
  s.homepage    = "http://sportslabs.com"
  s.summary     = "%q{This is the OasConfig app wrapper}"
  s.description = "%q{This is the OasConfig app wrapper}"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"
  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rake"
  s.add_development_dependency "rs"
  s.add_development_dependency "webmock"

  s.add_dependency "faraday", "~> 0.9.0"
  s.add_dependency "faraday_middleware"
  s.add_dependency "activesupport"
  s.add_dependency "activemodel"
  s.add_dependency "oj"
end
