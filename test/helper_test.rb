require "webpacker_test"

class HelperTest < ActionView::TestCase
  def setup
    @view = ActionView::Base.new
    @view.extend Webpacker::Helper
  end

  def test_asset_pack_path
    assert_equal @view.asset_pack_path("bootstrap.js"), "/packs/bootstrap-300631c4f0e0f9c865bc.js"
    assert_equal @view.asset_pack_path("bootstrap.css"), "/packs/bootstrap-c38deda30895059837cf.css"
  end

  def test_javascript_pack_tag
    script = %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js"></script>)
    assert_equal @view.javascript_pack_tag("bootstrap.js"), script
  end

  def test_stylesheet_pack_tag
    style = %(<link rel="stylesheet" media="screen" href="/packs/bootstrap-c38deda30895059837cf.css" />)
    assert_equal @view.stylesheet_pack_tag("bootstrap.css"), style
  end
end
