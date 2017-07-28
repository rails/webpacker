require "webpacker_test"

class DevServerTest < Minitest::Test
  require "webpacker_test"

  def check_assertion
    stub_value = ActiveSupport::StringInquirer.new("development")
    Webpacker.stub(:env, stub_value) do
      Webpacker::Configuration.reset
      Webpacker::DevServer.reset
      result = yield
      assert_equal(result[0], result[1])
    end
    Webpacker::Configuration.reset
    Webpacker::DevServer.reset
  end

  def test_dev_server?
    check_assertion { [true, Webpacker::DevServer.dev_server?] }
  end

  def test_dev_server_host
    check_assertion { ["localhost", Webpacker::DevServer.host] }
  end

  def test_dev_server_port
    check_assertion { [8080, Webpacker::DevServer.port] }
  end

  def test_dev_server_hot?
    check_assertion { [false, Webpacker::DevServer.hot?] }

    ENV.stub(:[], "TRUE") do
      check_assertion { [true, Webpacker::DevServer.hot?] }
    end

    ENV.stub(:[], "FALSE") do
      check_assertion { [false, Webpacker::DevServer.hot?] }
    end
    ENV.stub(:[], "true") do
      check_assertion { [true, Webpacker::DevServer.hot?] }
    end
  end

  def test_dev_server_https?
    check_assertion { [false, Webpacker::DevServer.https?] }
  end

  def test_dev_server_protocol?
    check_assertion { ["http", Webpacker::DevServer.protocol] }
  end

  def test_base_url?
    check_assertion { ["http://localhost:8080", Webpacker::DevServer.base_url] }
  end
end
