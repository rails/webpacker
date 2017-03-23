require "rails/railtie"

require "webpacker/helper"

class Webpacker::Engine < ::Rails::Engine
  initializer :webpacker do |app|
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    # Loads webpacker config data from config/webpack/paths.yml
    Webpacker::Configuration.load
    # Loads manifest data from public/packs/manifest.json
    Webpacker::Manifest.load
  end
end
