require "webpacker/source"

module Webpacker::Helper
  # Computes the full path for a given webpacker asset.
  # Return relative path using manifest.json and passes it to asset_url helper
  # This will use asset_path internally, so most of their behaviors will be the same.
  # If :type options is set, a file extension will be appended
  # If :host options is set, it overwrites global config.action_controller.asset_host setting
  # Examples:
  #
  # In development mode:
  #   <%= asset_pack_path 'calendar.js' %> # => "/packs/calendar.js"
  # In production mode:
  #   <%= asset_pack_path 'calendar.css' %> # => "/packs/calendar-1016838bab065ae1e122.css"
  #
  # With type option:
  #   <%= asset_pack_path 'calendar', type: :javascript %> # => "/packs/calendar.js"
  # When asset_host option is given:
  #   <%= asset_pack_path 'calendar', type: :javascript %> # =>
  #   "http://example.com/packs/calendar.js"
  def asset_pack_path(name, **options)
    asset_path(Webpacker::Source.new(name, **options).path, **options)
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
    javascript_include_tag(Webpacker::Source.new(name, type: :javascript).path, **options)
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
    stylesheet_link_tag(Webpacker::Source.new(name, type: :stylesheet).path, **options)
  end
end
