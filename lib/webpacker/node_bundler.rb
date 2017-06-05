# Finds available global or local node package manager - yarn or npm

require "webpacker/configuration"

module Webpacker::NodeBundler
  extend self

  def name
    @package ||= packages.find(-> { raise Errno::ENOENT }) { |package| available?(package) }

  rescue Errno::ENOENT
    $stderr.puts "Node package managers npm and yarn not found! Scanned following paths for executables - #{packages}"
    $stderr.puts "Make sure either npm or yarn is installed globally, or locally within your app node_modules folder."
    exit!
  end

  def command
    commands[name]
  end

  def command_dev
    commands[:dev][name]
  end

  private

    def available?(package)
      null_device = Gem.win_platform? ? "/nul 2>&1" : "/dev/null 2>&1"
      system("#{package} --version > #{null_device}")
    end

    def commands
      commands = { dev: {} }

      yarn.each do |package|
        commands["#{package}"]       = "#{package} add"
        commands[:dev]["#{package}"] = "#{package} add --dev"
      end

      npm.each do |package|
        commands["#{package}"]       = "#{package} install --save"
        commands[:dev]["#{package}"] = "#{package} install --save-dev"
      end

      commands
    end

    def packages
      [*yarn, *npm]
    end

    def yarn
      %W(
        yarn
        #{Webpacker::Configuration.node_modules_bin_path}/yarn
        yarnpkg
        #{Webpacker::Configuration.node_modules_bin_path}/yarnpkg
      ).freeze
    end

    def npm
      %W(
        npm
        #{Webpacker::Configuration.node_modules_bin_path}/npm
      ).freeze
    end
end
