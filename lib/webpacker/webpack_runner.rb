require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    ALLOWED_PARAMS = {
      '--debug': "--inspect-brk",
      '--stack-size': "--stack-size"
    }.freeze

    def run
      env = Webpacker::Compiler.env

      cmd = build_node_params

      cmd += if node_modules_bin_exist?
        ["#{@node_modules_bin_path}/webpack"]
      else
        ["yarn", "webpack"]
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

      def build_node_params
        arguments = Hash[ ARGV.collect { |arg| arg.split("=") } ]
        allowed_params = ALLOWED_PARAMS.keys & arguments.keys.map(&:to_sym)

        ["node"] + allowed_params.map do |param|
          value = arguments[param.to_s]
          ALLOWED_PARAMS[param] + (value ? "=#{value}" : "")
        end
      end
  end
end
