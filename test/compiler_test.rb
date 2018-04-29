require "test_helper"

class CompilerTest < Minitest::Test
  def remove_compilation_digest_path
    Webpacker.compiler.send(:compilation_digest_path).tap do |path|
      path.delete if path.exist?
    end
  end

  def setup
    remove_compilation_digest_path
  end

  def teardown
    remove_compilation_digest_path
  end

  def test_custom_environment_variables
    assert Webpacker.compiler.send(:webpack_env)["FOO"] == nil
    Webpacker.compiler.env["FOO"] = "BAR"
    assert Webpacker.compiler.send(:webpack_env)["FOO"] == "BAR"
  end

  def test_default_watched_paths
    assert_equal Webpacker.compiler.send(:default_watched_paths), [
      "app/assets/**/*",
      "/etc/yarn/**/*",
      "test/test_app/app/javascript/**/*",
      "yarn.lock",
      "package.json",
      "config/webpack/**/*"
    ]
  end

  def test_freshness
    assert Webpacker.compiler.stale?
    assert !Webpacker.compiler.fresh?
  end

  def test_freshness_on_compile_success
    status = OpenStruct.new(success?: true)

    assert Webpacker.compiler.stale?
    Open3.stub :capture3, [:sterr, :stdout, status] do
      Webpacker.compiler.compile
      assert Webpacker.compiler.fresh?
    end
  end

  def test_staleness_on_compile_fail
    status = OpenStruct.new(success?: false)

    assert Webpacker.compiler.stale?
    Open3.stub :capture3, [:sterr, :stdout, status] do

      Webpacker.compiler.compile
      assert Webpacker.compiler.stale?
    end
  end

  def test_compilation_digest_path
    assert Webpacker.compiler.send(:compilation_digest_path).to_s.ends_with?(Webpacker.env)
  end
end
