eject_template_path = File.expand_path("../../eject/template.rb", __dir__).freeze
bin_path = ENV["BUNDLE_BIN"] || "./bin"

namespace :webpacker do
  desc "Eject Webpacker binstubs in this application"
  task :eject do
    if Rails::VERSION::MAJOR >= 5
      exec "#{RbConfig.ruby} #{bin_path}/rails app:template LOCATION=#{eject_template_path}"
    else
      exec "#{RbConfig.ruby} #{bin_path}/rake rails:template LOCATION=#{eject_template_path}"
    end
  end
end
