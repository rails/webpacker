namespace :webpacker do
  desc "Verifies if yarn is installed"
  task :check_yarn do
    required_yarn_version = "0.20.1"

    begin
      yarn_version = `yarn --version`

      raise Errno::ENOENT if yarn_version.blank? || Gem::Version.new(yarn_version) < Gem::Version.new(required_yarn_version)
    rescue Errno::ENOENT
      puts "Webpacker requires Yarn version >= #{required_yarn_version}. Please download and install the latest version from https://yarnpkg.com/lang/en/docs/install/"
      puts "Exiting!" && exit!
    end
  end
end
