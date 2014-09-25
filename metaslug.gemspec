$:.push File.expand_path("../lib", __FILE__)

require "metaslug/version"

Gem::Specification.new do |s|
  s.name        = "metaslug"
  s.version     = Metaslug::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martin Catty"]
  s.email       = ["mcatty@synbioz.com"]
  s.homepage    = "https://github.com/synbioz/metaslug"
  s.summary     = "Set metas according to a path."
  s.description = "Metaslug allows you to set your metas information in a localized YAML file."
  s.license     = "MIT"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3"
end
