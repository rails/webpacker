namespace :webpacker do
  desc "Verifies that bin/webpacker is present"
  task :check_binstubs do
    unless File.exist?(Rails.root.join("bin/webpacker"))
      $stderr.puts "webpacker binstub not found.\n"\
           "Have you run rails webpacker:install ?\n"\
           "Make sure the bin directory and bin/webpacker are not included in .gitignore\n"\
           "Exiting!"
      exit!
    end
  end
end
