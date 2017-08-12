require "webpacker_test_helper"

class DevServerTest < Minitest::Test
  def test_host
    assert_equal "localhost", Webpacker.dev_server.host
  end

  def test_port
    assert_equal 3035, Webpacker.dev_server.port
  end

  def test_https?
    assert_equal false, Webpacker.dev_server.https?
  end

  def protocol
    assert_equal "http", Webpacker.dev_server.protocol
  end
end
