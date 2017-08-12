require "webpacker_test_helper"

class DevServerTest < Minitest::Test
  def test_host
    assert_equal "localhost", Webpacker.dev_server.host
  end

  def test_port
    assert_equal Webpacker.dev_server.port, 3035
  end
end
