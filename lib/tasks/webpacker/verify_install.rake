require "webpacker/configuration"

namespace :webpacker do
  desc "Verifies if webpacker is installed"
  task verify_install: [:check_node, :check_yarn, :check_binstubs] do
    if File.exist?(Webpacker::Configuration.file_path)
      Webpacker.logger.info "Webpacker is installed 🎉 🍰"
      Webpacker.logger.info "Using #{Webpacker::Configuration.file_path} file for setting up webpack paths"
    else
      Webpacker.logger.error "Configuration config/webpacker.yml file not found. \n"\
           "Make sure webpacker:install is run successfully before " \
           "running dependent tasks"
      exit!
    end
  end
end
