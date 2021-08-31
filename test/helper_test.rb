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
  end

  def test_asset_pack_url
    assert_equal "https://example.com/packs/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_url("bootstrap.js")
    assert_equal "https://example.com/packs/bootstrap-c38deda30895059837cf.css", asset_pack_url("bootstrap.css")
  end

  def test_image_pack_path
    assert_equal "/packs/application-k344a6d59eef8632c9d1.png", image_pack_path("application.png")
    assert_equal "/packs/static/image-c38deda30895059837cf.jpg", image_pack_path("image.jpg")
    assert_equal "/packs/static/image-c38deda30895059837cf.jpg", image_pack_path("static/image.jpg")
    assert_equal "/packs/static/nested/image-c38deda30895059837cf.jpg", image_pack_path("nested/image.jpg")
    assert_equal "/packs/static/nested/image-c38deda30895059837cf.jpg", image_pack_path("static/nested/image.jpg")
  end

  def test_image_pack_url
    assert_equal "https://example.com/packs/application-k344a6d59eef8632c9d1.png", image_pack_url("application.png")
    assert_equal "https://example.com/packs/static/image-c38deda30895059837cf.jpg", image_pack_url("image.jpg")
    assert_equal "https://example.com/packs/static/image-c38deda30895059837cf.jpg", image_pack_url("static/image.jpg")
    assert_equal "https://example.com/packs/static/nested/image-c38deda30895059837cf.jpg", image_pack_url("nested/image.jpg")
    assert_equal "https://example.com/packs/static/nested/image-c38deda30895059837cf.jpg", image_pack_url("static/nested/image.jpg")
  end

  def test_image_pack_tag
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/application-k344a6d59eef8632c9d1.png\" width=\"16\" height=\"10\" />",
      image_pack_tag("application.png", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/static/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/static/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("static/image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/static/nested/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("nested/image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/static/nested/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("static/nested/image.jpg", size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img srcset=\"/packs/static/image-2x-7cca48e6cae66ec07b8e.jpg 2x\" src=\"/packs/static/image-c38deda30895059837cf.jpg\" />",
      image_pack_tag("static/image.jpg", srcset: { "static/image-2x.jpg" => "2x" })
  end

  def test_favicon_pack_tag
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/application-k344a6d59eef8632c9d1.png\" />",
      favicon_pack_tag("application.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/static/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("mb-icon.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/static/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("static/mb-icon.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/static/nested/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("nested/mb-icon.png", rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/packs/static/nested/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("static/nested/mb-icon.png", rel: "apple-touch-icon", type: "image/png")
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

  def test_javascript_pack_tag
    assert_equal \
      %(<script src="/packs/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js" defer="defer"></script>\n) +
        %(<script src="/packs/vendors~application-e55f2aae30c07fb6d82a.chunk.js" defer="defer"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js" defer="defer"></script>\n) +
        %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js" defer="defer"></script>),
      javascript_pack_tag("application", "bootstrap")
  end

  def test_javascript_pack_with_no_defer_tag
    assert_equal \
      %(<script src="/packs/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js"></script>\n) +
        %(<script src="/packs/vendors~application-e55f2aae30c07fb6d82a.chunk.js"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js"></script>\n) +
        %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js"></script>),
      javascript_pack_tag("application", "bootstrap", defer: false)
  end

  def test_javascript_pack_tag_splat
    assert_equal \
      %(<script src="/packs/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js" defer="defer"></script>\n) +
        %(<script src="/packs/vendors~application-e55f2aae30c07fb6d82a.chunk.js" defer="defer"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js" defer="defer"></script>),
      javascript_pack_tag("application", defer: true)
  end

  def test_javascript_pack_tag_symbol
    assert_equal \
      %(<script src="/packs/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js" defer="defer"></script>\n) +
        %(<script src="/packs/vendors~application-e55f2aae30c07fb6d82a.chunk.js" defer="defer"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js" defer="defer"></script>),
      javascript_pack_tag(:application)
  end

  def application_stylesheet_chunks
    %w[/packs/1-c20632e7baf2c81200d3.chunk.css /packs/application-k344a6d59eef8632c9d1.chunk.css]
  end

  def hello_stimulus_stylesheet_chunks
    %w[/packs/hello_stimulus-k344a6d59eef8632c9d1.chunk.css]
  end

  def test_stylesheet_pack_tag
    assert_equal \
      (application_stylesheet_chunks + hello_stimulus_stylesheet_chunks)
        .map { |chunk| stylesheet_link_tag(chunk) }.join("\n"),
      stylesheet_pack_tag("application", "hello_stimulus")
  end

  def test_stylesheet_pack_tag_symbol
    assert_equal \
      (application_stylesheet_chunks + hello_stimulus_stylesheet_chunks)
        .map { |chunk| stylesheet_link_tag(chunk) }.join("\n"),
      stylesheet_pack_tag(:application, :hello_stimulus)
  end

  def test_stylesheet_pack_tag_splat
    assert_equal \
      (application_stylesheet_chunks).map { |chunk| stylesheet_link_tag(chunk, media: "all") }.join("\n"),
      stylesheet_pack_tag("application", media: "all")
  end
end
