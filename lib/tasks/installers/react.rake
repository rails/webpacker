REACT_TEMPLATE_PATH = File.expand_path("../../install/react.rb", __dir__)

namespace :webpacker do
  namespace :install do
    desc "Install everything needed for react"
    task react: ["webpacker:verify_install"] do
      if Rails::VERSION::MAJOR >= 5
        exec "./bin/rails app:template LOCATION=#{REACT_TEMPLATE_PATH}"
      else
        exec "./bin/rake rails:template LOCATION=#{REACT_TEMPLATE_PATH}"
      end
    end
  end
end
