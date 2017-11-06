namespace :webpacker do
  desc "Verifies that webpack & webpack-dev-server are present."
  task :check_binstubs do
    unless Bundler.which("webpack") && Bundler.which("webpack-dev-server")
      $stderr.puts "webpack binstubs not found.\n"\
           "Have you run rails webpacker:install ?\n"\
           "Make sure the bin directory or binstubs are not included in .gitignore\n"\
           "Exiting!"
      exit!
    end
  end
end
