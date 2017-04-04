namespace :webpacker do
  desc "Verifies if yarn is installed"
  task :check_yarn do
    begin
      `yarn --version`
    rescue Errno::ENOENT
      puts "Webpacker requires yarn. Please download and install Yarn https://yarnpkg.com/lang/en/docs/install/"
      puts "Exiting!" && exit!
    end
  end
end
