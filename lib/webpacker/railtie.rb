require "rails/railtie"

require "webpacker/helper"

class Webpacker::Engine < ::Rails::Engine
  initializer "webpacker.helper" do |app|
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    ActiveSupport.on_load :action_view do
      include Webpacker::Helper
    end
  end

  initializer "webpacker.logger" do
    config.after_initialize do |app|
      Webpacker.logger = ::Rails.logger
    end
  end

  initializer "webpacker.bootstrap" do
    Webpacker.bootstrap
    Spring.after_fork { Webpacker.bootstrap } if defined?(Spring)
  end
end
