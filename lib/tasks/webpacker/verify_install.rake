require "webpacker/configuration"

namespace :webpacker do
  desc "Verifies if Webpacker is installed"
  task verify_install: [:check_node, :check_yarn, :check_binstubs] do
    unless Webpacker.config.config_path.exist?
      path = Webpacker.config.config_path.relative_path_from(Pathname.new(pwd)).to_s
      $stderr.puts "Configuration #{path} file not found. \n"\
           "Make sure webpacker:install is run successfully before " \
           "running dependent tasks"
      exit!
    end
  end
end
