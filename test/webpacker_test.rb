require 'test_helper'

class WebpackerTest < MiniTest::Test
  def test_version
    refute_nil Webpacker::VERSION
  end
end
