$:.push File.expand_path("../lib", __FILE__)
require "webpacker/version"

Gem::Specification.new do |s|
  s.name     = "webpacker"
  s.version  = Webpacker::VERSION
  s.authors  = [ "David Heinemeier Hansson", "Gaurav Tiwari" ]
  s.email    = [ "david@basecamp.com", "gaurav@gauravtiwari.co.uk" ]
  s.summary  = "Use webpack to manage app-like JavaScript modules in Rails"
  s.homepage = "https://github.com/rails/webpacker"
  s.license  = "MIT"

  s.metadata = {
    "source_code_uri" => "https://github.com/rails/webpacker/tree/v#{Webpacker::VERSION}",
    "changelog_uri"   => "https://github.com/rails/webpacker/blob/v#{Webpacker::VERSION}/CHANGELOG.md"
  }

  s.required_ruby_version = ">= 2.4.0"

  s.add_dependency "activesupport", ">= 5.2"
  s.add_dependency "railties",      ">= 5.2"
  s.add_dependency "rack-proxy",    ">= 0.6.1"
  s.add_dependency "semantic_range", ">= 2.3.0"

  s.add_development_dependency "bundler", ">= 1.3.0"
  s.add_development_dependency "rubocop", "< 0.69"
  s.add_development_dependency "rubocop-performance"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
end
