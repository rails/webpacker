require "webpacker_test_helper"

class ConfigurationTest < Minitest::Test
  def test_source_path
    source_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/app/javascript").to_s
    assert_equal source_path, Webpacker.config.source_path.to_s
  end

  def test_source_entry_path
    source_entry_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/app/javascript", "packs").to_s
    assert_equal Webpacker.config.source_entry_path.to_s, source_entry_path
  end

  def test_public_output_path
    public_output_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public/packs-test").to_s
    assert_equal Webpacker.config.public_output_path.to_s, public_output_path
  end

  def test_public_manifest_path
    public_manifest_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public/packs-test", "manifest.json").to_s
    assert_equal Webpacker.config.public_manifest_path.to_s, public_manifest_path
  end

  def test_cache_path
    cache_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/tmp/cache/webpacker").to_s
    assert_equal Webpacker.config.cache_path.to_s, cache_path
  end

  def test_compile?
    assert Webpacker.config.compile?
  end
end
