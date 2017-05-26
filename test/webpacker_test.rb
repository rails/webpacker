# frozen_string_literal: true

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "webpacker"

module TestApp
  class Application < ::Rails::Application
    config.root = File.join(File.dirname(__FILE__), "test_app")
    config.eager_load = true
  end
end

TestApp::Application.initialize!
