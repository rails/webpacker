require "test_helper"

class WebpackerTest < Minitest::Test
  def test_default_logger
    assert Webpacker.logger.respond_to?(:info)
  end

  def test_set_logger
    Webpacker.logger = :another_logger
    assert_equal Webpacker.logger, :another_logger
  end
end
