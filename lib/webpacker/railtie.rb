require "rails/railtie"

require "webpacker/helper"

class Webpacker::Engine < ::Rails::Engine
  initializer :webpacker do |app|
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    # Load config from package.json or initialise with defaults
    # when running rails webpacker:install
    Webpacker::PackageJson.load
    webpacker_config = Webpacker::PackageJson.webpacker

    if !(webpacker_config && webpacker_config[:distPath])
      webpacker_config = { distPath: "public/packs", digestFileName: "digests.json" }
    end

    Webpacker::Manifest.load(
      Rails.root.join(webpacker_config[:distPath], webpacker_config[:digestFileName])
    )
  end
end
