require "test_helper"

class DevServerTest < Webpacker::Test
  def test_running?
    with_node_env("production") do
      reloaded_config
      refute Webpacker.dev_server.running?
    end
  end

  def test_host
    with_node_env("development") do
      reloaded_config
      assert_equal Webpacker.dev_server.host, "localhost"
    end
  end

  def test_port
    with_node_env("development") do
      reloaded_config
      assert_equal Webpacker.dev_server.port, 3035
    end
  end

  def test_https?
    with_node_env("development") do
      reloaded_config
      assert_equal Webpacker.dev_server.https?, false
    end
  end
end
