require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    def run
      cmd = [ "#{@node_modules_path}/.bin/webpack", "--config", @webpack_config ] + @argv

      Dir.chdir(@app_path) do
        exec env, *cmd
      end
    end
  end
end
