require "webpacker_test"

class ManifestTest < Minitest::Test
  def test_file_path
    file_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    assert_equal Webpacker::Manifest.file_path.to_s, file_path
  end

  def test_lookup_exception
    manifest_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    asset_file = "calendar.js"

    error = assert_raises Webpacker::FileLoader::NotFoundError do
      Webpacker::Manifest.lookup(asset_file)
    end

    assert_equal error.message, "Can't find #{asset_file} in #{manifest_path}. Is webpack still compiling?"
  end

  def test_lookup_success
    asset_file = "bootstrap.js"
    assert_equal Webpacker::Manifest.lookup(asset_file), "/packs/bootstrap-300631c4f0e0f9c865bc.js"
  end

  def test_lookup_path
    file_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "bootstrap-300631c4f0e0f9c865bc.js").to_s
    asset_file = "bootstrap.js"
    assert_equal Webpacker::Manifest.lookup_path(asset_file).to_s, file_path
  end
end
