require "webpacker/configuration"

namespace :webpacker do
  namespace :install do
    desc "Verifies if webpacker is installed"
    task :verify do
      begin
        File.read(Webpacker::Configuration.file_path)
      rescue Errno::ENOENT
        puts "Configuration config/webpack/paths.yml file not found. \n"\
             "Make sure webpacker:install is run successfully before " \
             "running dependent tasks"
        exit!
      end
    end
  end
end
