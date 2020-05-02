require "test_helper"

class ConfigurationTest < Webpacker::Test
  def setup
    @config = Webpacker::Configuration.new(
      root_path: Pathname.new(File.expand_path("test_app", __dir__)),
      config_path: Pathname.new(File.expand_path("./test_app/config/webpacker.yml", __dir__)),
      env: "production"
    )
  end

  def test_source_path
    source_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/app/javascript").to_s
    assert_equal source_path, @config.source_path.to_s
  end

  def test_source_path_globbed
    assert_equal @config.source_path_globbed,
                 "app/javascript/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg,.elm}"
  end

  def test_source_entry_path
    source_entry_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/app/javascript", "packs").to_s
    assert_equal @config.source_entry_path.to_s, source_entry_path
  end

  def test_public_root_path
    public_root_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public").to_s
    assert_equal @config.public_path.to_s, public_root_path
  end

  def test_public_output_path
    public_output_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public/packs").to_s
    assert_equal @config.public_output_path.to_s, public_output_path

    @config = Webpacker::Configuration.new(
      root_path: @config.root_path,
      config_path: Pathname.new(File.expand_path("./test_app/config/webpacker_public_root.yml", __dir__)),
      env: "production"
    )

    public_output_path = File.expand_path File.join(File.dirname(__FILE__), "public/packs").to_s
    assert_equal @config.public_output_path.to_s, public_output_path
  end

  def test_public_manifest_path
    public_manifest_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    assert_equal @config.public_manifest_path.to_s, public_manifest_path
  end

  def test_cache_path
    cache_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/tmp/cache/webpacker").to_s
    assert_equal @config.cache_path.to_s, cache_path
  end

  def test_additional_paths
    assert_equal @config.additional_paths, ["app/assets", "/etc/yarn", "app/elm"]
  end

  def test_additional_paths_globbed
    assert_equal @config.additional_paths_globbed, [
      "app/assets/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg,.elm}",
      "/etc/yarn/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg,.elm}",
      "app/elm/**/*{.mjs,.js,.sass,.scss,.css,.module.sass,.module.scss,.module.css,.png,.svg,.gif,.jpeg,.jpg,.elm}"
    ]
  end

  def test_extensions
    config_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/config/webpacker.yml").to_s
    webpacker_yml = YAML.load_file(config_path)
    assert_equal @config.extensions, webpacker_yml["default"]["extensions"]
  end

  def test_cache_manifest?
    assert @config.cache_manifest?

    with_rails_env("development") do
      refute Webpacker.config.cache_manifest?
    end

    with_rails_env("test") do
      refute Webpacker.config.cache_manifest?
    end
  end

  def test_compile?
    refute @config.compile?

    with_rails_env("development") do
      assert Webpacker.config.compile?
    end

    with_rails_env("test") do
      assert Webpacker.config.compile?
    end
  end

  def test_extract_css?
    assert @config.extract_css?

    with_rails_env("development") do
      refute Webpacker.config.extract_css?
    end

    with_rails_env("test") do
      refute Webpacker.config.extract_css?
    end
  end
end
