namespace :webpacker do
  desc "Verifies if Node.js is installed"
  task :check_node do
    begin
      node_version = `node -v`
      required_node_version = "6.4"

      raise Errno::ENOENT if node_version.blank?
      if Gem::Version.new(node_version.strip.tr("v", "")) < Gem::Version.new(required_node_version)
        puts "Webpacker requires Node.js >= v#{required_node_version} and you are using #{node_version}"
        puts "Please upgrade Node.js https://nodejs.org/en/download/"
        puts "Exiting!" && exit!
      end
    rescue Errno::ENOENT
      puts "Node.js not installed. Please download and install Node.js https://nodejs.org/en/download/"
      puts "Exiting!" && exit!
    end
  end
end
