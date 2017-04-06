namespace :webpacker do
  desc "Verifies if Node.js is installed"
  task :check_node do
    begin
      node_version = `node -v`
      major_version, minor_version = node_version.tr("v", "").split(".").map(&:to_i)
      if (major_version < 6) || (major_version == 6 && minor_version < 4)
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
