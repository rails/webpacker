# frozen_string_literal: true

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "webpacker"

class WebpackerTest < Minitest::Test
  def test_caching
    assert_equal Webpacker.caching, false
  end
end

module TestApp
  class Application < ::Rails::Application
    config.root = File.join(File.dirname(__FILE__), "test_app")
    config.eager_load = false
  end
end

TestApp::Application.initialize!
