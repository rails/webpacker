require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    def run
      env = Webpacker::Compiler.env
      env["WEBPACKER_CONFIG"] = @webpacker_config

      cmd = if node_modules_bin_exist?
        ["#{@node_modules_bin_path}/webpack"]
      else
        ["yarn", "webpack"]
      end

      if @argv.include?("--debug-webpacker")
        cmd = [ "node", "--inspect-brk"] + cmd
      end

      cmd += ["--config", @webpack_config] + @argv

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
