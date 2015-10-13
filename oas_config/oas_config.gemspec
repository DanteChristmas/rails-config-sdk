$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "oas_config/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "oas_config"
  s.version     = OasConfig::VERSION
  s.authors     = ["Josh Sullivan"]
  s.email       = ["jsullivan@silverchalice.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of OasConfig."
  s.description = "TODO: Description of OasConfig."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
