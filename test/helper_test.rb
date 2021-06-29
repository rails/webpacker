require "test_helper"

module HelperTests
  def setup
    @request = Class.new do
      def send_early_hints(links) end
      def base_url
        "https://example.com"
      end
    end.new
  end

  def test_asset_pack_path
    assert_equal "/#{@output_path}/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_path("bootstrap.js", webpacker: @webpacker)
    assert_equal "/#{@output_path}/bootstrap-c38deda30895059837cf.css", asset_pack_path("bootstrap.css", webpacker: @webpacker)
  end

  def test_asset_pack_url
    assert_equal "https://example.com/#{@output_path}/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_url("bootstrap.js", webpacker: @webpacker)
    assert_equal "https://example.com/#{@output_path}/bootstrap-c38deda30895059837cf.css", asset_pack_url("bootstrap.css", webpacker: @webpacker)
  end

  def test_image_pack_path
    assert_equal "/#{@output_path}/application-k344a6d59eef8632c9d1.png", image_pack_path("application.png", webpacker: @webpacker)
    assert_equal "/#{@output_path}/media/images/image-c38deda30895059837cf.jpg", image_pack_path("image.jpg", webpacker: @webpacker)
    assert_equal "/#{@output_path}/media/images/image-c38deda30895059837cf.jpg", image_pack_path("media/images/image.jpg", webpacker: @webpacker)
    assert_equal "/#{@output_path}/media/images/nested/image-c38deda30895059837cf.jpg", image_pack_path("nested/image.jpg", webpacker: @webpacker)
    assert_equal "/#{@output_path}/media/images/nested/image-c38deda30895059837cf.jpg", image_pack_path("media/images/nested/image.jpg", webpacker: @webpacker)
  end

  def test_image_pack_url
    assert_equal "https://example.com/#{@output_path}/application-k344a6d59eef8632c9d1.png", image_pack_url("application.png", webpacker: @webpacker)
    assert_equal "https://example.com/#{@output_path}/media/images/image-c38deda30895059837cf.jpg", image_pack_url("image.jpg", webpacker: @webpacker)
    assert_equal "https://example.com/#{@output_path}/media/images/image-c38deda30895059837cf.jpg", image_pack_url("media/images/image.jpg", webpacker: @webpacker)
    assert_equal "https://example.com/#{@output_path}/media/images/nested/image-c38deda30895059837cf.jpg", image_pack_url("nested/image.jpg", webpacker: @webpacker)
    assert_equal "https://example.com/#{@output_path}/media/images/nested/image-c38deda30895059837cf.jpg", image_pack_url("media/images/nested/image.jpg", webpacker: @webpacker)
  end

  def test_image_pack_tag
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/#{@output_path}/application-k344a6d59eef8632c9d1.png\" width=\"16\" height=\"10\" />",
      image_pack_tag("application.png", webpacker: @webpacker, size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/#{@output_path}/media/images/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("image.jpg", webpacker: @webpacker, size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/#{@output_path}/media/images/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("media/images/image.jpg", webpacker: @webpacker, size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/#{@output_path}/media/images/nested/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("nested/image.jpg", webpacker: @webpacker, size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/#{@output_path}/media/images/nested/image-c38deda30895059837cf.jpg\" width=\"16\" height=\"10\" />",
      image_pack_tag("media/images/nested/image.jpg", webpacker: @webpacker, size: "16x10", alt: "Edit Entry")
    assert_equal \
      "<img srcset=\"/#{@output_path}/media/images/image-2x-7cca48e6cae66ec07b8e.jpg 2x\" src=\"/#{@output_path}/media/images/image-c38deda30895059837cf.jpg\" />",
      image_pack_tag("media/images/image.jpg", webpacker: @webpacker, srcset: { "media/images/image-2x.jpg" => "2x" })
  end

  def test_favicon_pack_tag
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/#{@output_path}/application-k344a6d59eef8632c9d1.png\" />",
      favicon_pack_tag("application.png", webpacker: @webpacker, rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/#{@output_path}/media/images/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("mb-icon.png", webpacker: @webpacker, rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/#{@output_path}/media/images/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("media/images/mb-icon.png", webpacker: @webpacker, rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/#{@output_path}/media/images/nested/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("nested/mb-icon.png", webpacker: @webpacker, rel: "apple-touch-icon", type: "image/png")
    assert_equal \
      "<link rel=\"apple-touch-icon\" type=\"image/png\" href=\"/#{@output_path}/media/images/nested/mb-icon-c38deda30895059837cf.png\" />",
      favicon_pack_tag("media/images/nested/mb-icon.png", webpacker: @webpacker, rel: "apple-touch-icon", type: "image/png")
  end

  def test_preload_pack_asset
    if self.class.method_defined?(:preload_link_tag)
      assert_equal \
        %(<link rel="preload" href="/#{@output_path}/fonts/fa-regular-400-944fb546bd7018b07190a32244f67dc9.woff2" as="font" type="font/woff2" crossorigin="anonymous">),
        preload_pack_asset("fonts/fa-regular-400.woff2", webpacker: @webpacker)
    else
      error = assert_raises do
        preload_pack_asset("fonts/fa-regular-400.woff2", webpacker: @webpacker)
      end

      assert_equal \
        "You need Rails >= 5.2 to use this tag.",
        error.message
    end
  end

  def test_javascript_pack_tag
    assert_equal \
      %(<script src="/#{@output_path}/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js"></script>\n) +
        %(<script src="/#{@output_path}/vendors~application-e55f2aae30c07fb6d82a.chunk.js"></script>\n) +
        %(<script src="/#{@output_path}/application-k344a6d59eef8632c9d1.js"></script>\n) +
        %(<script src="/#{@output_path}/bootstrap-300631c4f0e0f9c865bc.js"></script>),
      javascript_pack_tag("application", "bootstrap", webpacker: @webpacker)
  end

  def test_javascript_pack_tag_splat
    assert_equal \
      %(<script src="/#{@output_path}/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js" defer="defer"></script>\n) +
        %(<script src="/#{@output_path}/vendors~application-e55f2aae30c07fb6d82a.chunk.js" defer="defer"></script>\n) +
        %(<script src="/#{@output_path}/application-k344a6d59eef8632c9d1.js" defer="defer"></script>),
      javascript_pack_tag("application", webpacker: @webpacker, defer: true)
  end

  def test_javascript_pack_tag_symbol
    assert_equal \
      %(<script src="/#{@output_path}/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js"></script>\n) +
        %(<script src="/#{@output_path}/vendors~application-e55f2aae30c07fb6d82a.chunk.js"></script>\n) +
        %(<script src="/#{@output_path}/application-k344a6d59eef8632c9d1.js"></script>),
      javascript_pack_tag(:application, webpacker: @webpacker)
  end

  def application_stylesheet_chunks
    %W[/#{@output_path}/1-c20632e7baf2c81200d3.chunk.css /#{@output_path}/application-k344a6d59eef8632c9d1.chunk.css]
  end

  def hello_stimulus_stylesheet_chunks
    %W[/#{@output_path}/hello_stimulus-k344a6d59eef8632c9d1.chunk.css]
  end

  def test_stylesheet_pack_tag
    assert_equal \
      (application_stylesheet_chunks + hello_stimulus_stylesheet_chunks)
        .map { |chunk| stylesheet_link_tag(chunk) }.join("\n"),
      stylesheet_pack_tag("application", "hello_stimulus", webpacker: @webpacker)
  end

  def test_stylesheet_pack_tag_symbol
    assert_equal \
      (application_stylesheet_chunks + hello_stimulus_stylesheet_chunks)
        .map { |chunk| stylesheet_link_tag(chunk) }.join("\n"),
      stylesheet_pack_tag(:application, :hello_stimulus, webpacker: @webpacker)
  end

  def test_stylesheet_pack_tag_splat
    assert_equal \
      (application_stylesheet_chunks).map { |chunk| stylesheet_link_tag(chunk, media: "all") }.join("\n"),
      stylesheet_pack_tag("application", webpacker: @webpacker, media: "all")
  end
end

class HelperTest < ActionView::TestCase
  tests Webpacker::Helper
  include HelperTests

  attr_reader :request

  def setup
    super
    @webpacker = nil
    @output_path = "packs"
  end
end

class HelperTestWithExplicitWebpacker < ActionView::TestCase
  tests Webpacker::Helper
  include HelperTests

  attr_reader :request

  def setup
    super
    @webpacker = ::Webpacker::Instance.new config_path: Rails.root.join("config/webpacker_other_location.yml")
    @output_path = "other-packs"
  end
end
