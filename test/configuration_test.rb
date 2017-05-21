require "webpacker_test"

class ConfigurationTest < Minitest::Test
  def test_entry_path
    entry_path = File.join(File.dirname(__FILE__), "test_app/app/javascript", "packs").to_s
    assert_equal Webpacker::Configuration.entry_path.to_s, entry_path
  end

  def test_file_path
    file_path = File.join(File.dirname(__FILE__), "test_app/config", "webpacker.yml").to_s
    assert_equal Webpacker::Configuration.file_path.to_s, file_path
  end

  def test_manifest_path
    manifest_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    assert_equal Webpacker::Configuration.manifest_path.to_s, manifest_path
  end

  def test_output_path
    output_path = File.join(File.dirname(__FILE__), "test_app/public/packs").to_s
    assert_equal Webpacker::Configuration.output_path.to_s, output_path
  end

  def test_source
    assert_equal Webpacker::Configuration.source.to_s, "app/javascript"
  end

  def test_source_path
    source_path = File.join(File.dirname(__FILE__), "test_app/app/javascript").to_s
    assert_equal Webpacker::Configuration.source_path.to_s, source_path
  end
end
