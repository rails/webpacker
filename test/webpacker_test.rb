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
end
