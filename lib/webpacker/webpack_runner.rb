require "erb"
require "yaml"
require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    def run
      compile_config
      env = Webpacker::Compiler.env
      cmd = [ "#{@node_modules_bin_path}/webpack", "--config", @webpack_config ] + @argv

      Dir.chdir(@app_path) do
        exec env, *cmd
      end
    end

    private

      # config/webpacker.yml may contain ERB that needs to be processed so that javascript can proceed
      def compile_config
        config_file = File.join("config", "webpacker.yml")
        config = YAML.load(ERB.new(File.read(config_file)).result)[env].deep_symbolize_keys
        processed_config_file = File.join("config", ".webpacker.yml")
        File.open(processed_config_file, "w") do |f|
          f.write(config.to_yaml)
        end
      end
  end
end
