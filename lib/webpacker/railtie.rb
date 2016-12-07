require 'rails/railtie'

require 'webpacker/helper'
require 'webpacker/digests'

class Webpacker::Engine < ::Rails::Engine
  initializer :webpacker do
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    if Rails.configuration.x.webpacker[:digesting]
      Webpacker::Digests.load \
        Rails.application.config.x.webpacker[:digests_path] ||
          Rails.root.join('public/packs/digests.json')
    end
  end
end
