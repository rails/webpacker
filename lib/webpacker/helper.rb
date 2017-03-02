require "webpacker/source"
require "webpacker/package_json"

module Webpacker::Helper
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
    filename = File.basename(name, ".js")
    filename += ".js"
    javascript_include_tag(Webpacker::Source.new(filename).path, **options)
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
    webpacker_config = Webpacker::PackageJson.webpacker
    unless webpacker_config[:assets]
      raise StandardError,
                        "Stylesheet support is not enabled. Install using " \
                        "webpacker:install:assets"
    end

    filename = File.basename(name, ".css")
    filename += ".css"
    stylesheet_link_tag(Webpacker::Source.new(filename).path, **options)
  end
end
