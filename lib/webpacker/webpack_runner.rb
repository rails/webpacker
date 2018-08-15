require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    def run
      env = Webpacker::Compiler.env.merge("NODE_PATH" => @node_modules_path.shellescape)
      cmd = [ "#{@node_modules_path}/.bin/webpack", "--config", @webpack_config ] + @argv

      Dir.chdir(@app_path) do
        exec env, *cmd
      end
    end
  end
end
