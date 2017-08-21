require "webpacker_test_helper"

class ManifestTest < Minitest::Test
  def test_lookup_exception
    manifest_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public/packs", "manifest.json").to_s
    asset_file = "calendar.js"

    Webpacker.config.stub :compile?, false do
      error = assert_raises Webpacker::Manifest::MissingEntryError do
        Webpacker.manifest.lookup(asset_file)
      end

      expected = <<-MSG
Webpacker can't find #{asset_file} in #{manifest_path}. Possible causes:
1. You want to set wepbacker.yml value of compile to true for your environment
   unless you are using the `webpack -w` or the webpack-dev-server.
2. Webpack has not yet re-run to reflect updates.
3. You have misconfigured Webpacker's config/webpacker.yml file.
4. Your Webpack configuration is not creating a manifest.
Your manifest contains:
{
  "bootstrap.css": "/packs/bootstrap-c38deda30895059837cf.css",
  "application.css": "/packs/application-dd6b1cd38bfa093df600.css",
  "bootstrap.js": "/packs/bootstrap-300631c4f0e0f9c865bc.js",
  "application.js": "/packs/application-k344a6d59eef8632c9d1.js"
}
     MSG

      assert_equal expected, error.message
    end
  end

  def test_lookup_success
    assert_equal Webpacker.manifest.lookup("bootstrap.js"), "/packs/bootstrap-300631c4f0e0f9c865bc.js"
  end
end
