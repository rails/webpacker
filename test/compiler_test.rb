require "webpacker_test_helper"

class CompilerTest < Minitest::Test
  def setup
    Webpacker.compiler.send(:compilation_timestamp_path).delete
  end

  def test_freshness
    assert Webpacker.compiler.stale?
    assert !Webpacker.compiler.fresh?
  end
end
