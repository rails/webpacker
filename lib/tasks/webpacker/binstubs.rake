binstubs_template_path = File.expand_path("../../install/binstubs.rb", __dir__).freeze
bin_path = ENV["BUNDLE_BIN"] || Rails.root.join("bin")

namespace :webpacker do
  desc "Installs Webpacker binstubs in this application"
  task binstubs: [:check_node, :check_yarn] do |task|
    prefix = task.name.split(/#|webpacker:binstubs/).first

    if Rails::VERSION::MAJOR >= 5
      exec "#{RbConfig.ruby} #{bin_path}/rails #{prefix}app:template LOCATION=#{binstubs_template_path}"
    else
      exec "#{RbConfig.ruby} #{bin_path}/rake #{prefix}rails:template LOCATION=#{binstubs_template_path}"
    end
  end
end
