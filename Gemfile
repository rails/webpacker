source "https://rubygems.org"

gemspec

gem "rails"
gem "rake", ">= 11.1"
gem "rubocop", [">= 0.49", "< 0.60"], require: false # 0.60.0 doesn't work on ruby 2.6. When a new version is released, we'll remove this version lock. https://github.com/rubocop-hq/rubocop/issues/6412
gem "rack-proxy", require: false

group :test do
  gem "minitest", "~> 5.0"
  gem "byebug"
end
