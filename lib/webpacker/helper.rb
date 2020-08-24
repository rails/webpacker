module Webpacker::Helper
  # Returns the current Webpacker instance.
  # Could be overridden to use multiple Webpacker
  # configurations within the same app (e.g. with engines).
  def current_webpacker_instance
    Webpacker.instance
  end

  # Computes the relative path for a given Webpacker asset.
  # Returns the relative path using manifest.json and passes it to path_to_asset helper.
  # This will use path_to_asset internally, so most of their behaviors will be the same.
  #
  # Example:
  #
  #   # When extract_css is false in webpacker.yml and the file is a css:
  #   <%= asset_pack_path 'calendar.css' %>  # => nil
  #
  #   # When extract_css is true in webpacker.yml or the file is not a css:
  #   <%= asset_pack_path 'calendar.css' %> # => "/packs/calendar-1016838bab065ae1e122.css"
  def asset_pack_path(name, **options)
    if current_webpacker_instance.config.extract_css? || !stylesheet?(name)
      path_to_asset(current_webpacker_instance.manifest.lookup!(name), options)
    end
  end

  # Computes the absolute path for a given Webpacker asset.
  # Returns the absolute path using manifest.json and passes it to url_to_asset helper.
  # This will use url_to_asset internally, so most of their behaviors will be the same.
  #
  # Example:
  #
  #   # When extract_css is false in webpacker.yml and the file is a css:
  #   <%= asset_pack_url 'calendar.css' %> # => nil
  #
  #   # When extract_css is true in webpacker.yml or the file is not a css:
  #   <%= asset_pack_url 'calendar.css' %> # => "http://example.com/packs/calendar-1016838bab065ae1e122.css"
  def asset_pack_url(name, **options)
    if current_webpacker_instance.config.extract_css? || !stylesheet?(name)
      url_to_asset(current_webpacker_instance.manifest.lookup!(name), options)
    end
  end

  # Creates an image tag that references the named pack file.
  #
  # Example:
  #
  #  <%= image_pack_tag 'application.png', size: '16x10', alt: 'Edit Entry' %>
  #  <img alt='Edit Entry' src='/packs/application-k344a6d59eef8632c9d1.png' width='16' height='10' />
  #
  #  <%= image_pack_tag 'picture.png', srcset: { 'picture-2x.png' => '2x' } %>
  #  <img srcset= "/packs/picture-2x-7cca48e6cae66ec07b8e.png 2x" src="/packs/picture-c38deda30895059837cf.png" >
  def image_pack_tag(name, **options)
    if options[:srcset] && !options[:srcset].is_a?(String)
      options[:srcset] = options[:srcset].map do |src_name, size|
        "#{resolve_path_to_image(src_name)} #{size}"
      end.join(", ")
    end

    image_tag(resolve_path_to_image(name), options)
  end

  # Creates a link tag for a favicon that references the named pack file.
  #
  # Example:
  #
  #  <%= favicon_pack_tag 'mb-icon.png', rel: 'apple-touch-icon', type: 'image/png' %>
  #  <link href="/packs/mb-icon-k344a6d59eef8632c9d1.png" rel="apple-touch-icon" type="image/png" />
  def favicon_pack_tag(name, **options)
    favicon_link_tag(resolve_path_to_image(name), options)
  end

  # Creates a script tag that references the named pack file, as compiled by webpack per the entries list
  # in package/environments/base.js. By default, this list is auto-generated to match everything in
  # app/javascript/packs/*.js. In production mode, the digested reference is automatically looked up.
  #
  # Example:
  #
  #   <%= javascript_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   <script src="/packs/calendar-1016838bab065ae1e314.js" data-turbolinks-track="reload"></script>
  def javascript_pack_tag(*names, **options)
    javascript_include_tag(*sources_from_manifest_entries(names, type: :javascript), **options)
  end

  # Creates script tags that reference the js chunks from entrypoints when using split chunks API,
  # as compiled by webpack per the entries list in package/environments/base.js.
  # By default, this list is auto-generated to match everything in
  # app/javascript/packs/*.js and all the dependent chunks. In production mode, the digested reference is automatically looked up.
  # See: https://webpack.js.org/plugins/split-chunks-plugin/
  #
  # Example:
  #
  #   <%= javascript_packs_with_chunks_tag 'calendar', 'map', 'data-turbolinks-track': 'reload' %> # =>
  #   <script src="/packs/vendor-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
  #   <script src="/packs/calendar~runtime-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
  #   <script src="/packs/calendar-1016838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
  #   <script src="/packs/map~runtime-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
  #   <script src="/packs/map-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
  #
  # DO:
  #
  #   <%= javascript_packs_with_chunks_tag 'calendar', 'map' %>
  #
  # DON'T:
  #
  #   <%= javascript_packs_with_chunks_tag 'calendar' %>
  #   <%= javascript_packs_with_chunks_tag 'map' %>
  def javascript_packs_with_chunks_tag(*names, **options)
    javascript_include_tag(*sources_from_manifest_entrypoints(names, type: :javascript), **options)
  end

  # Creates a link tag, for preloading, that references a given Webpacker asset.
  # In production mode, the digested reference is automatically looked up.
  # See: https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content
  #
  # Example:
  #
  #   <%= preload_pack_asset 'fonts/fa-regular-400.woff2' %> # =>
  #   <link rel="preload" href="/packs/fonts/fa-regular-400-944fb546bd7018b07190a32244f67dc9.woff2" as="font" type="font/woff2" crossorigin="anonymous">
  def preload_pack_asset(name, **options)
    if self.class.method_defined?(:preload_link_tag)
      preload_link_tag(current_webpacker_instance.manifest.lookup!(name), options)
    else
      raise "You need Rails >= 5.2 to use this tag."
    end
  end

  # Creates a link tag that references the named pack file, as compiled by webpack per the entries list
  # in package/environments/base.js. By default, this list is auto-generated to match everything in
  # app/javascript/packs/*.js. In production mode, the digested reference is automatically looked up.
  #
  # Note: If the development server is running and hot module replacement is active, this will return nothing.
  # In that setup you need to configure your styles to be inlined in your JavaScript for hot reloading.
  #
  # Examples:
  #
  #   # When extract_css is false in webpacker.yml:
  #   <%= stylesheet_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   nil
  #
  #   # When extract_css is true in webpacker.yml:
  #   <%= stylesheet_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   <link rel="stylesheet" media="screen" href="/packs/calendar-1016838bab065ae1e122.css" data-turbolinks-track="reload" />
  def stylesheet_pack_tag(*names, **options)
    if current_webpacker_instance.config.extract_css?
      stylesheet_link_tag(*sources_from_manifest_entries(names, type: :stylesheet), **options)
    end
  end

  # Creates link tags that reference the css chunks from entrypoints when using split chunks API,
  # as compiled by webpack per the entries list in package/environments/base.js.
  # By default, this list is auto-generated to match everything in
  # app/javascript/packs/*.js and all the dependent chunks. In production mode, the digested reference is automatically looked up.
  # See: https://webpack.js.org/plugins/split-chunks-plugin/
  #
  # Examples:
  #
  #   <%= stylesheet_packs_with_chunks_tag 'calendar', 'map' %> # =>
  #   <link rel="stylesheet" media="screen" href="/packs/3-8c7ce31a.chunk.css" />
  #   <link rel="stylesheet" media="screen" href="/packs/calendar-8c7ce31a.chunk.css" />
  #   <link rel="stylesheet" media="screen" href="/packs/map-8c7ce31a.chunk.css" />
  #
  # DO:
  #
  #   <%= stylesheet_packs_with_chunks_tag 'calendar', 'map' %>
  #
  # DON'T:
  #
  #   <%= stylesheet_packs_with_chunks_tag 'calendar' %>
  #   <%= stylesheet_packs_with_chunks_tag 'map' %>
  def stylesheet_packs_with_chunks_tag(*names, **options)
    if current_webpacker_instance.config.extract_css?
      stylesheet_link_tag(*sources_from_manifest_entrypoints(names, type: :stylesheet), **options)
    end
  end

  private
    def stylesheet?(name)
      File.extname(name) == ".css"
    end

    def sources_from_manifest_entries(names, type:)
      names.map { |name| current_webpacker_instance.manifest.lookup!(name, type: type) }.flatten
    end

    def sources_from_manifest_entrypoints(names, type:)
      names.map { |name| current_webpacker_instance.manifest.lookup_pack_with_chunks!(name, type: type) }.flatten.uniq
    end

    def resolve_path_to_image(name)
      path = name.starts_with?("media/images/") ? name : "media/images/#{name}"
      path_to_asset(current_webpacker_instance.manifest.lookup!(path))
    rescue
      path_to_asset(current_webpacker_instance.manifest.lookup!(name))
    end
end
