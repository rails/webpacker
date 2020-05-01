require "test_helper"

class HelperTest < ActionView::TestCase
  tests Webpacker::Helper

  attr_reader :request

  def setup
    @request = Class.new do
      def send_early_hints(links) end
      def base_url
        "https://example.com"
      end
    end.new
  end

  def test_asset_pack_path
    assert_equal "/packs/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_path("bootstrap.js")
    assert_equal "/packs/bootstrap-c38deda30895059837cf.css", asset_pack_path("bootstrap.css")

    Webpacker.config.stub :extract_css?, false do
      assert_nil asset_pack_path("bootstrap.css")
      assert_equal "/packs/application-k344a6d59eef8632c9d1.png", asset_pack_path("application.png")
    end
  end

  def test_asset_pack_url
    assert_equal "https://example.com/packs/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_url("bootstrap.js")
    assert_equal "https://example.com/packs/bootstrap-c38deda30895059837cf.css", asset_pack_url("bootstrap.css")

    Webpacker.config.stub :extract_css?, false do
      assert_nil asset_pack_path("bootstrap.css")
      assert_equal "https://example.com/packs/application-k344a6d59eef8632c9d1.png", asset_pack_url("application.png")
    end
  end

  def test_image_pack_tag
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/application-k344a6d59eef8632c9d1.png\" width=\"16\" height=\"10\" />",
      image_pack_tag("application.png", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/media/images/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/media/images/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("media/images/image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/media/images/nested/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("nested/image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/media/images/nested/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("media/images/nested/image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img srcset=\"/packs/media/images/image-2x-7cca48e6cae66ec07b8e.jpg 2x\" src=\"/packs/media/images/image-c38deda30895059837cf.jpg\" />",
      image_pack_tag("media/images/image.jpg", srcset: { "media/images/image-2x.jpg" => "2x" })
  end

  def test_favicon_pack_tag
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/application-k344a6d59eef8632c9d1.png\" />",
      favicon_pack_tag("application.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/media/images/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("mb-icon.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/media/images/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("media/images/mb-icon.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/media/images/nested/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("nested/mb-icon.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/media/images/nested/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("media/images/nested/mb-icon.png", rel: "apple-touch-icon", type: "image/png")
  end

  def test_javascript_pack_tag
    assert_equal \
      %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js"></script>),
      javascript_pack_tag("bootstrap.js")
  end

  def test_javascript_pack_tag_symbol
    assert_equal \
      %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js"></script>),
      javascript_pack_tag(:bootstrap)
  end

  def test_javascript_pack_tag_splat
    assert_equal \
      %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js" defer="defer"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js" defer="defer"></script>),
      javascript_pack_tag("bootstrap.js", "application.js", defer: true)
  end

  def test_javascript_pack_tag_split_chunks
    assert_equal \
      %(<script src="/packs/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js"></script>\n) +
        %(<script src="/packs/vendors~application-e55f2aae30c07fb6d82a.chunk.js"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js"></script>),
      javascript_packs_with_chunks_tag("application")
  end

  def test_preload_pack_asset
    if self.class.method_defined?(:preload_link_tag)
      assert_equal \
        %(<link rel="preload" href="/packs/fonts/fa-regular-400-944fb546bd7018b07190a32244f67dc9.woff2" as="font" type="font/woff2" crossorigin="anonymous">),
        preload_pack_asset("fonts/fa-regular-400.woff2")
    else
      error = assert_raises do
        preload_pack_asset("fonts/fa-regular-400.woff2")
      end

      assert_equal \
        "You need Rails >= 5.2 to use this tag.",
        error.message
    end
  end

  def test_stylesheet_pack_tag_split_chunks
    assert_equal \
      %(<link rel="stylesheet" media="screen" href="/packs/1-c20632e7baf2c81200d3.chunk.css" />\n) +
        %(<link rel="stylesheet" media="screen" href="/packs/application-k344a6d59eef8632c9d1.chunk.css" />\n) +
        %(<link rel="stylesheet" media="screen" href="/packs/hello_stimulus-k344a6d59eef8632c9d1.chunk.css" />),
      stylesheet_packs_with_chunks_tag("application", "hello_stimulus")
  end

  def test_stylesheet_pack_tag
    assert_equal \
      %(<link rel="stylesheet" media="screen" href="/packs/bootstrap-c38deda30895059837cf.css" />),
      stylesheet_pack_tag("bootstrap.css")
  end

  def test_stylesheet_pack_tag_symbol
    assert_equal \
      %(<link rel="stylesheet" media="screen" href="/packs/bootstrap-c38deda30895059837cf.css" />),
      stylesheet_pack_tag(:bootstrap)
  end

  def test_stylesheet_pack_tag_splat
    assert_equal \
      %(<link rel="stylesheet" media="all" href="/packs/bootstrap-c38deda30895059837cf.css" />\n) +
        %(<link rel="stylesheet" media="all" href="/packs/application-dd6b1cd38bfa093df600.css" />),
      stylesheet_pack_tag("bootstrap.css", "application.css", media: "all")
  end
end
