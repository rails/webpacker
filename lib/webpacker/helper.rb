module Webpacker::Helper
  # Computes the full path for a given webpacker asset.
  # Return relative path using manifest.json and passes it to asset_url helper
  # This will use asset_path internally, so most of their behaviors will be the same.
  # Examples:
  #
  # In development mode:
  #   <%= asset_pack_path 'calendar.js' %> # => "/packs/calendar.js"
  # In production mode:
  #   <%= asset_pack_path 'calendar.css' %> # => "/packs/calendar-1016838bab065ae1e122.css"
  def asset_pack_path(name, **options)
    asset_path(Webpacker::Manifest.lookup(name), **options)
  end
  # Creates a script tag that references the named pack file, as compiled by Webpack per the entries list
  # in config/webpack/shared.js. By default, this list is auto-generated to match everything in
  # app/javascript/packs/*.js. In production mode, the digested reference is automatically looked up.
  #
  # Examples:
  #
  #   # In development mode:
  #   <%= javascript_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   <script src="/packs/calendar.js" data-turbolinks-track="reload"></script>
  #
  #   # In production mode:
  #   <%= javascript_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   <script src="/packs/calendar-1016838bab065ae1e314.js" data-turbolinks-track="reload"></script>
  def javascript_pack_tag(name, **options)
    javascript_include_tag(Webpacker::Manifest.lookup("#{name}#{compute_asset_extname(name, type: :javascript)}"), **options)
  end

  # Creates a link tag that references the named pack file, as compiled by Webpack per the entries list
  # in config/webpack/shared.js. By default, this list is auto-generated to match everything in
  # app/javascript/packs/*.js. In production mode, the digested reference is automatically looked up.
  #
  # Examples:
  #
  #   # In development mode:
  #   <%= stylesheet_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   <link rel="stylesheet" media="screen" href="/packs/calendar.css" data-turbolinks-track="reload" />
  #
  #   # In production mode:
  #   <%= stylesheet_pack_tag 'calendar', 'data-turbolinks-track': 'reload' %> # =>
  #   <link rel="stylesheet" media="screen" href="/packs/calendar-1016838bab065ae1e122.css" data-turbolinks-track="reload" />
  def stylesheet_pack_tag(name, **options)
    stylesheet_link_tag(Webpacker::Manifest.lookup("#{name}#{compute_asset_extname(name, type: :stylesheet)}"), **options)
  end
end
