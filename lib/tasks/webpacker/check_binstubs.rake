namespace :webpacker do
  desc "Verifies that webpack & webpack-dev-server are present."
  task :check_binstubs do
    unless File.exist?("bin/webpack")
      $stderr.puts "webpack binstubs not found.\n"\
           "Have you run rails webpacker:install ?\n"\
           "Make sure the bin directory or binstubs are not included in .gitignore\n"\
    end
    
    unless File.exist?("bin/webpack-dev-server")
      $stderr.puts "webpack-dev-server binstubs not found.\n"\
           "Have you run rails webpacker:install ?\n"\
           "Make sure the bin directory or binstubs are not included in .gitignore\n"\
    end
    
    exit!
  end
end
