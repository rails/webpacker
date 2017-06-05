# Finds available global or local node package manager - yarn or npm

require "webpacker/configuration"

module Webpacker::NodeBundler
  extend self

  def name
    @package ||= packages.find(-> { raise Errno::ENOENT }) { |package| available?(package) }

  rescue Errno::ENOENT
    $stderr.puts "NPM and Yarn not found! Scanned following paths for executables - #{packages}"
    $stderr.puts "Make sure either NPM or Yarn is installed globally or locally within node_modules folder."

    exit!
  end

  def command
    commands[name.to_sym]
  end

  def available?(package)
    null_device = Gem.win_platform? ? "/nul 2>&1" : "/dev/null 2>&1"
    system("#{package} --version > #{null_device}")
  end

  private

    def commands
      {
        yarn: "yarn add",
        npm: "npm install"
      }.freeze
    end

    def packages
      %W(
        yarn
        #{Webpacker::Configuration.node_modules_bin_path}/yarn
        yarnpkg
        #{Webpacker::Configuration.node_modules_bin_path}/yarnpkg
        npm
        #{Webpacker::Configuration.node_modules_bin_path}/npm
      ).freeze
    end
end
