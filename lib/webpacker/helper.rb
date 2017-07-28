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
    path = Webpacker::Configuration.public_output_path
    file = Webpacker::Manifest.lookup(name)
    full_path = "#{path}/#{file}"
    asset_path(full_path, **options)
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
  def javascript_pack_tag(*names, **options)
    javascript_include_tag(*asset_source(names, :javascript), **options)
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
  #   # In development mode with hot-reloading
  #   <%= stylesheet_pack_tag('main') %> <% # Default is false for enabled_when_hot_loading%>
  #   # No output
  #
  #   # In development mode with hot-reloading and enabled_when_hot_loading
  #   # <%= stylesheet_pack_tag('main', enabled_when_hot_loading: true) %>
  #   <link rel="stylesheet" media="screen" href="/public/webpack/development/calendar-1016838bab065ae1e122.css" />
  #
  def stylesheet_pack_tag(*names, **options)
    return "" if Webpacker::DevServer.hot?
    stylesheet_link_tag(*asset_source(names, :stylesheet), **options)
  end

  private
    def asset_source(names, type)
      output_path_or_url = Webpacker::Configuration.output_path_or_url
      names.map do |name|
        path = Webpacker::Manifest.lookup("#{name}#{compute_asset_extname(name, type: type)}")
        "#{output_path_or_url}/#{path}"
      end
    end
end
