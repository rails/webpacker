require "rails/railtie"

require "webpacker/helper"
require "webpacker/env"

class Webpacker::Engine < ::Rails::Engine
  config.webpacker = ActiveSupport::OrderedOptions.new
  config.webpacker.cache = false

  initializer :webpacker do |app|
    Webpacker.cache = app.config.webpacker.cache

    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    ActiveSupport.on_load :action_view do
      include Webpacker::Helper
    end

    Webpacker.bootstrap
    Spring.after_fork { Webpacker.bootstrap } if defined?(Spring)
  end
end
