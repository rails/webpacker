# frozen_string_literal: true

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "webpacker"

module TestApp
  class Application < ::Rails::Application
    config.root = File.dirname(__FILE__)
  end
end

TestApp::Application.initialize!
