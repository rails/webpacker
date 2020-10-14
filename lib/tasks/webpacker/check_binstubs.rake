namespace :webpacker do
  desc "Verifies that bin/webpack is present"
  task :check_binstubs do
    unless File.exist?(Rails.root.join("bin/webpack"))
      $stderr.puts "webpack binstub not found.\n"\
           "Have you run rails webpacker:install ?\n"\
           "Make sure the bin directory and bin/webpack are not included in .gitignore\n"\
           "Exiting!"
      exit!
    end
  end
end
