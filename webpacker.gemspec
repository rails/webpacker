$:.push File.expand_path("../lib", __FILE__)
require "webpacker/version"

Gem::Specification.new do |s|
  s.name     = "webpacker"
  s.version  = Webpacker::VERSION
  s.authors  = "David Heinemeier Hansson"
  s.email    = "david@basecamp.com"
  s.summary  = "Use Webpack to manage app-like JavaScript modules in Rails"
  s.homepage = "https://github.com/rails/webpacker"
  s.license  = "MIT"

  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "activesupport", ">= 4.2"
  s.add_dependency "multi_json",    "~> 1.2"
  s.add_dependency "railties",      ">= 4.2"

  s.add_development_dependency "bundler", "~> 1.12"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.post_install_message = %{
    Webpacker installed! You now need to setup webpacker using
    following command - bundle exec rails webpacker:install

    After installation, you can link example javascript app pack available in
    application/javascript using this helper in your view,

    <%= javascript_pack_tag 'application' %>

    Don't forget to update the name of your app and description in package.json

    To check, list of commands available, run - bundle exec rails webpacker

    Important Notice: Your package.json file contains configuration for webpacker.
    Modify as needed, but do not remove otherwise your app will break.
  }
end
