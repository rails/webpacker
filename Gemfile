source "https://rubygems.org"

gemspec

gem 'rails', '3.2.22'
gem "rake", ">= 11.1"
gem "rack-proxy", require: false
gem "semantic_range", require: false

group :test do
  gem "minitest", "~> 5.0"
  gem "byebug"
end

group :development, :test do
  gem 'pry'
  gem 'rb-readline'
end