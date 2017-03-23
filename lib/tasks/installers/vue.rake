VUE_TEMPLATE_PATH = File.expand_path("../../install/vue.rb", __dir__)

namespace :webpacker do
  namespace :install do
    desc "Install everything needed for Vue"
    task vue: ["webpacker:verify_install"] do
      if Rails::VERSION::MAJOR >= 5
        exec "./bin/rails app:template LOCATION=#{VUE_TEMPLATE_PATH}"
      else
        exec "./bin/rake rails:template LOCATION=#{VUE_TEMPLATE_PATH}"
      end
    end
  end
end
