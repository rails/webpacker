require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    def run
      env = Webpacker::Compiler.env
      cmd = [ "#{@node_modules_bin_path}/webpack", "--config", @webpack_config ] + @argv

      Dir.chdir(@app_path) do
        exec env, *cmd
      end
    end
  end
end
