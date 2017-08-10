require "webpacker_test"

class CompilerTest < Minitest::Test
  def test_default_watched_paths
    assert_equal Webpacker::Compiler.default_watched_paths, ["app/javascript/**/*", "yarn.lock", "package.json", "config/webpack/**/*"]
  end

  def test_empty_watched_paths
    assert_equal Webpacker::Compiler.watched_paths, []
  end

  def test_watched_paths
    Webpacker::Compiler.stub :watched_paths, ["Gemfile"] do
      assert_equal Webpacker::Compiler.watched_paths, ["Gemfile"]
    end
  end

  def test_freshness
    assert Webpacker::Compiler.stale?
    assert !Webpacker::Compiler.fresh?
  end
end
