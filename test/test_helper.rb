# frozen_string_literal: true
require "minitest/autorun"
require "rails"
require "rails/test_help"
require "byebug"

require_relative "test_app/config/environment"

Rails.env = "production"

Webpacker.instance = ::Webpacker::Instance.new

class Webpacker::Test < Minitest::Test
  private
    def reloaded_config
      Webpacker.instance.instance_variable_set(:@env, nil)
      Webpacker.instance.instance_variable_set(:@config, nil)
      Webpacker.instance.instance_variable_set(:@dev_server, nil)
      Webpacker.env
      Webpacker.config
      Webpacker.dev_server
    end

    def with_rails_env(env)
      original = Rails.env
      Rails.env = ActiveSupport::StringInquirer.new(env)
      reloaded_config
      yield
    ensure
      Rails.env = ActiveSupport::StringInquirer.new(original)
      reloaded_config
    end
end
