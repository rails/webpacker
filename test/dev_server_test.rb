require "webpacker_test_helper"
require "reload_config_helper"

class DevServerTest < Minitest::Test
  include ReloadConfigHelper

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
end
