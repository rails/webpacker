require "test_helper"

class WebpackerTest < Webpacker::Test
  def test_config_params
    assert_equal Rails.env, Webpacker.config.env
    assert_equal Webpacker.instance.root_path, Webpacker.config.root_path
    assert_equal Webpacker.instance.config_path, Webpacker.config.config_path

    with_rails_env("test") do
      assert_equal "test", Webpacker.config.env
    end
  end

  def test_erb_config_compilation
    with_rails_env("development") do
      assert_equal false, Webpacker.config.dev_server[:https]
      assert_equal 'localhost', Webpacker.config.dev_server[:host]
    end

    ENV['WEBPACKER_DEV_USE_HTTP'] = 'true'
    ENV['WEBPACKER_DEV_HOST'] = 'host.local'

    with_rails_env("development") do
      assert_equal true, Webpacker.config.dev_server[:https]
      assert_equal 'host.local', Webpacker.config.dev_server[:host]
    end

    ENV.delete('WEBPACKER_DEV_USE_HTTP')
    ENV.delete('WEBPACKER_DEV_HOST')
  end
end
