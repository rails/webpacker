require "rails/railtie"

require "webpacker/helper"
require "webpacker/env"

class Webpacker::Engine < ::Rails::Engine
  initializer :webpacker do |app|
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    # Setup NODE_ENV environment based on config/webpack/paths.yml
    Webpacker::Env.load
    # Loads webpacker config data from config/webpack/paths.yml
    Webpacker::Configuration.load
    # Loads manifest data from public/packs/manifest.json
    Webpacker::Manifest.load
  end
end
