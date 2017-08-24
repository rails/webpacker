require "webpacker_test_helper"

class CompilerTest < Minitest::Test
  def setup
    Webpacker.compiler.send(:compilation_digest_path).tap do |path|
      path.delete if path.exist?
    end
  end

  def test_freshness
    assert Webpacker.compiler.stale?
    assert !Webpacker.compiler.fresh?
  end
end
