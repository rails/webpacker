source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec path: "../"

gem "rails", '~>6.1.0'
gem "arel", github: "rails/arel"
gem "rake", ">= 11.1"
gem "rack-proxy", require: false
gem "minitest", "~> 5.0"
gem "byebug"
