require "webpacker_test"

class DevServerTest < Minitest::Test
  require "webpacker_test"

  def reset
    Webpacker::Configuration.instance_variable_set(:@defaults, nil)
    Webpacker::Configuration.instance_variable_set(:@instance, nil)
    # Webpacker::Configuration.load_instance
    Webpacker::DevServer.instance_variable_set(:@instance, nil)
    # Webpacker::DevServer.load_instance
  end

  def check_assertion
    reset
    stub_value = ActiveSupport::StringInquirer.new("development")
    Webpacker.stub(:env, stub_value) do
      Webpacker::DevServer.stub(:data, dev_server: {}) do
        result = yield
        assert_equal(result[0], result[1])
      end
    end
    reset
  end

  def test_dev_server?
    check_assertion { [true, Webpacker::DevServer.enabled?] }
  end

  def test_dev_server_host
    check_assertion { ["localhost", Webpacker::DevServer.host] }
  end

  def test_dev_server_port
    check_assertion { [8080, Webpacker::DevServer.port] }
  end

  def test_dev_server_hot?
    check_assertion { [false, Webpacker::DevServer.hot_reloading?] }

    ENV.stub(:[], "TRUE") do
      check_assertion { [true, Webpacker::DevServer.hot_reloading?] }
    end

    ENV.stub(:[], "FALSE") do
      check_assertion { [false, Webpacker::DevServer.hot_reloading?] }
    end
    ENV.stub(:[], "true") do
      check_assertion { [true, Webpacker::DevServer.hot_reloading?] }
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
