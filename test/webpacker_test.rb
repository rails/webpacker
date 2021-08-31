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

  def test_inline_css_no_dev_server
    assert !Webpacker.inlining_css?
  end

  def test_inline_css_with_hmr
    dev_server = Webpacker::DevServer.new({})
    def dev_server.host; "localhost"; end
    def dev_server.port; "3035"; end
    def dev_server.pretty?; false; end
    def dev_server.https?; true; end
    def dev_server.hmr?; true; end
    def dev_server.running?; true; end
    Webpacker.instance.stub(:dev_server, dev_server) do
      assert Webpacker.inlining_css?
    end
  end
end
