install_template_path = File.expand_path("../../install/template.rb", __dir__).freeze
bin_path = ENV["BUNDLE_BIN"] || "./bin"

namespace :webpacker do
  desc "Install Webpacker in this application"
  task install: [:check_node, :check_yarn] do
    if Rails::VERSION::MAJOR >= 5
      exec "#{RbConfig.ruby} #{bin_path}/rails app:template LOCATION=#{install_template_path}"
    else
      exec "#{RbConfig.ruby} #{bin_path}/rake rails:template LOCATION=#{install_template_path}"
    end
  end
end
