require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    WEBPACK_COMMANDS = [
      "help",
      "h",
      "--help",
      "-h",
      "version",
      "v",
      "--version",
      "-v",
      "info",
      "i"
    ].freeze

    def run
      env = Webpacker::Compiler.env
      env["WEBPACKER_CONFIG"] = @webpacker_config

      cmd = if node_modules_bin_exist?
        ["#{@node_modules_bin_path}/webpack"]
      else
        ["yarn", "webpack"]
      end

      if @argv.delete "--debug-webpacker"
        cmd = ["node", "--inspect-brk"] + cmd
        @argv.delete "--debug-webpacker"
      end

      if @argv.delete "--trace-deprecation"
        cmd = ["node", "--trace-deprecation"] + cmd
      end

      if @argv.delete "--no-deprecation"
        cmd = ["node", "--no-deprecation"] + cmd
      end

      # Webpack commands are not compatible with --config option.
      if (@argv & WEBPACK_COMMANDS).empty?
        cmd += ["--config", @webpack_config]
      end

      cmd += @argv

      Dir.chdir(@app_path) do
        Kernel.exec env, *cmd
      end
    end

    private
      def node_modules_bin_exist?
        File.exist?("#{@node_modules_bin_path}/webpack")
      end
  end
end
