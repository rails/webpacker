require "webpacker_test_helper"

class CompilerTest < Minitest::Test
  def setup
    compilation_timestamp_path = Webpacker.compiler.send(:compilation_timestamp_path)
    compilation_timestamp_path.delete if compilation_timestamp_path.exist?
  end

  def test_freshness
    assert Webpacker.compiler.stale?
    assert !Webpacker.compiler.fresh?
  end
end
