namespace :webpacker do
  desc "Verifies if Node.js is installed"
  task :check_node do
    begin
      node_version = `node -v`
      if node_version.tr("v", "").to_f < 6.4
        puts "Webpacker requires Node.js >= 6.4 and you are using #{node_version}"
        puts "Please upgrade Node.js https://nodejs.org/en/download/"
        puts "Exiting!" && exit!
      end
    rescue Errno::ENOENT
      puts "Node.js not installed. Please download and install Node.js https://nodejs.org/en/download/"
      puts "Exiting!" && exit!
    end
  end
end
