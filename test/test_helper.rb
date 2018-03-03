# frozen_string_literal: true
require "minitest/autorun"
require "rails"
require "rails/test_help"
require "byebug"

require_relative "test_app/config/environment"

ENV["NODE_ENV"] = "production"

Webpacker.instance = Webpacker::Instance.new \
  root_path: Pathname.new(File.expand_path("test_app", __dir__)),
  config_path: Pathname.new(File.expand_path("./test_app/config/webpacker.yml", __dir__))

class Webpacker::Test < Minitest::Test
  private
    def reloaded_config
      Webpacker.instance.instance_variable_set(:@env, nil)
      Webpacker.instance.instance_variable_set(:@config, nil)
      Webpacker.env
      Webpacker.config
    end

    def with_node_env(env)
      original = ENV["NODE_ENV"]
      ENV["NODE_ENV"] = env
      yield
    ensure
      ENV["NODE_ENV"] = original
    end
end
