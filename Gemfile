source "https://rubygems.org"

gemspec

gem "rails"
gem "rake", ">= 11.1"
gem "rubocop", ">= 0.47", require: false

group :test do
  gem "minitest", "~> 5.0"
end

if ENV["USE_PRY"]
  gem "awesome_print"
  gem "pry"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "pry-rescue"
  gem "pry-stack_explorer"
end
