require "test_helper"

class DevServerTest < Webpacker::Test
  def test_running?
    refute Webpacker.dev_server.running?
  end

  def test_host
    with_rails_env("development") do
      assert_equal Webpacker.dev_server.host, "localhost"
    end
  end

  def test_port
    with_rails_env("development") do
      assert_equal Webpacker.dev_server.port, 3035
    end
  end

  def test_https?
    with_rails_env("development") do
      assert_equal Webpacker.dev_server.https?, false
    end
  end

  def test_protocol
    with_rails_env("development") do
      assert_equal Webpacker.dev_server.protocol, "http"
    end
  end

  def test_host_with_port
    with_rails_env("development") do
      assert_equal Webpacker.dev_server.host_with_port, "localhost:3035"
    end
  end

  def test_pretty?
    with_rails_env("development") do
      refute Webpacker.dev_server.pretty?
    end
  end

  def test_default_env_prefix
    assert_equal Webpacker::DevServer::DEFAULT_ENV_PREFIX, "WEBPACKER_DEV_SERVER"
  end
end
