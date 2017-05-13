require "webpacker/configuration"

namespace :webpacker do
  desc "Verifies if webpacker is installed"
  task verify_install: [:check_node, :check_yarn] do
    if File.exist?(Webpacker::Configuration.file_path) && File.exist?("bin/webpack") && File.exist?("bin/webpack-dev-server")
      puts "Webpacker is installed 🎉 🍰"
      puts "Using #{Webpacker::Configuration.file_path} file for setting up webpack paths"
    else

      puts "Configuration config/webpack/paths.yml file not found. \n"\
           "Make sure webpacker:install is run successfully before " \
           "running dependent tasks" \
           unless File.exist?(Webpacker::Configuration.file_path)

      puts "Webpacker's binstubs not found. \n"\
            "Make sure the bin directory or binstubs are not included in .gitignore" \
            unless File.exist?("bin/webpack") && File.exist?("bin/webpack-dev-server")
      exit!
    end
  end
end
