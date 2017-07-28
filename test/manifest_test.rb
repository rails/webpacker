require "webpacker_test"

class ManifestTest < Minitest::Test
  def test_file_path
    file_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    assert_equal(Webpacker::Manifest.file_path.to_s, file_path)
  end

  def test_lookup_exception
    manifest_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    asset_file = "calendar.js"
    msg = <<-MSG
        Webpacker can't find #{asset_file} in your manifest at #{manifest_path}. Possible causes:
          1. You are hot reloading.
          2. You want to set Configuration.compile to true for your environment.
          3. Webpack has not re-run to reflect updates.
          4. You have misconfigured Webpacker's config/webpacker.yml file.
          5. Your Webpack configuration is not creating a manifest.
    MSG

    Webpacker::Configuration.stub :compile?, false do
      error = assert_raises Webpacker::FileLoader::NotFoundError do
        Webpacker::Manifest.lookup(asset_file)
      end

      assert_equal(error.message, msg)
    end
  end

  def test_lookup_success
    asset_file = "bootstrap.js"
    assert_equal("bootstrap-300631c4f0e0f9c865bc.js", Webpacker::Manifest.lookup(asset_file))
  end

  def test_lookup_path
    file_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "bootstrap-300631c4f0e0f9c865bc.js").to_s
    asset_file = "bootstrap.js"
    assert_equal(file_path, Webpacker::Manifest.lookup_path(asset_file).to_s)
  end

  def test_file_not_existing
    begin
      file_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json")
      temp_path = "#{file_path}.backup"
      FileUtils.mv(file_path, temp_path)
      # Point of this test is to ensure no crash
      Webpacker::Manifest.load_instance
      assert_equal({}, Webpacker::Manifest.instance.data)
    ensure
      FileUtils.mv(temp_path, file_path)
      Webpacker::Manifest.instance = nil
      Webpacker::Manifest.load_instance
    end
  end

  def test_lookup_success
    asset_file = "bootstrap.js"
    assert_equal("bootstrap-300631c4f0e0f9c865bc.js", Webpacker::Manifest.lookup(asset_file))
  end

  def test_confirm_manifest_exists_for_existing
    Webpacker::Manifest.instance.confirm_manifest_exists
  end

  def test_confirm_manifest_exists_for_missing
    assert_raises do
      Webpacker::Manifest.stub :path, "non-existent-file" do
        confirm_manifest_exists
      end
    end
  end

  def test_lookup_path_no_throw_missing_file
    value = Webpacker::Manifest.lookup_path_no_throw("non-existent-bundle.js")
    assert_nil(value)
  end

  def test_lookup_path_no_throw_file_exists
    file_path = File.join(File.dirname(__FILE__), "test_app/public/packs", "bootstrap-300631c4f0e0f9c865bc.js").to_s
    asset_file = "bootstrap.js"
    assert_equal(file_path, Webpacker::Manifest.lookup_path_no_throw(asset_file).to_s)
  end
end
