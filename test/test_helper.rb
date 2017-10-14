# frozen_string_literal: true
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "byebug"
require "test_app/config/environment"

ENV["NODE_ENV"] ||= "production"

Webpacker.instance = Webpacker::Instance.new \
  root_path: Pathname.new(File.expand_path("test_app", __dir__)),
  config_path: Pathname.new(File.expand_path("../lib/install/config/webpacker.yml", __dir__))

class Webpacker::Test < Minitest::Test
  private
    def reloaded_config
      Webpacker.instance.instance_variable_set(:@config, nil)
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
