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
    assert_nil Webpacker.compiler.send(:webpack_env)["FOO"]
    Webpacker.compiler.env["FOO"] = "BAR"
    assert Webpacker.compiler.send(:webpack_env)["FOO"] == "BAR"
  ensure
    Webpacker.compiler.env = {}
  end

  def test_default_watched_paths
    assert_equal Webpacker.compiler.send(:default_watched_paths), [
      "app/assets/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg}",
      "/etc/yarn/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg}",
      "app/javascript/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg}",
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

  def test_freshness_on_compile_fail
    status = OpenStruct.new(success?: false)

    assert Webpacker.compiler.stale?
    Open3.stub :capture3, [:sterr, :stdout, status] do
      Webpacker.compiler.compile
      assert Webpacker.compiler.fresh?
    end
  end

  def test_compilation_digest_path
    assert_equal Webpacker.compiler.send(:compilation_digest_path).basename.to_s, "last-compilation-digest-#{Webpacker.env}"
  end

  def test_external_env_variables
    assert_nil Webpacker.compiler.send(:webpack_env)["WEBPACKER_ASSET_HOST"]
    assert_nil Webpacker.compiler.send(:webpack_env)["WEBPACKER_RELATIVE_URL_ROOT"]

    ENV["WEBPACKER_ASSET_HOST"] = "foo.bar"
    ENV["WEBPACKER_RELATIVE_URL_ROOT"] = "/baz"
    assert_equal Webpacker.compiler.send(:webpack_env)["WEBPACKER_ASSET_HOST"], "foo.bar"
    assert_equal Webpacker.compiler.send(:webpack_env)["WEBPACKER_RELATIVE_URL_ROOT"], "/baz"
  end
end
