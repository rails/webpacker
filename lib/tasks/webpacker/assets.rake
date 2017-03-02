STATIC_APP_TEMPLATE_PATH = File.expand_path("../../install/templates/assets.rb", __dir__)

namespace :webpacker do
  namespace :install do
    desc "Add static assets(images and styles) support to webpacker"
    task assets: ["webpacker:install:verify"] do
      if Rails::VERSION::MAJOR >= 5
        exec "./bin/rails app:template LOCATION=#{STATIC_APP_TEMPLATE_PATH}"
      else
        exec "./bin/rake rails:template LOCATION=#{STATIC_APP_TEMPLATE_PATH}"
      end
    end
  end
end
