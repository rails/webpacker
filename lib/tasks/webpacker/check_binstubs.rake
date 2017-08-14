namespace :webpacker do
  desc "Verifies that bin/webpack & bin/webpack-dev-server are present."
  task :check_binstubs do
    unless File.exist?("config/webpacker.yml")
      $stderr.puts "config/webpacker.yml not found.\n"\
           "If using the default webpacker setup, have you run rails webpacker:install ?\n"\
           "Make sure the bin directory or binstubs are not included in .gitignore\n"\
           "Otherwise, please manually create a config/webpacker.yml file.\n"\
           "Exiting!"
      exit!
    end
  end
end
