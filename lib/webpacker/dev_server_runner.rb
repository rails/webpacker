require "shellwords"
require "yaml"
require "socket"
require "webpacker/runner"

module Webpacker
  class DevServerRunner < Webpacker::Runner
    def run
      load_config
      detect_port!
      execute_cmd
    end

    private

      def load_config
        @config_file = File.join(@app_path, "config/webpacker.yml")
        @default_listen_host_addr = ENV["NODE_ENV"] == "development" ? "localhost" : "0.0.0.0"

        dev_server = YAML.load_file(@config_file)[ENV["RAILS_ENV"]]["dev_server"]

        @hostname          = args("--host") || dev_server["host"]
        @port              = args("--port") || dev_server["port"]
        @https             = @argv.include?("--https") || dev_server["https"]
        @dev_server_addr   = "http#{"s" if @https}://#{@hostname}:#{@port}"
        @listen_host_addr  = args("--listen-host") || @default_listen_host_addr

      rescue Errno::ENOENT, NoMethodError
        $stdout.puts "Webpack dev_server configuration not found in #{@config_file}."
        $stdout.puts "Please run bundle exec rails webpacker:install to install webpacker"
        exit!
      end

      def detect_port!
        server = TCPServer.new(@listen_host_addr, @port)
        server.close

      rescue Errno::EADDRINUSE
        $stdout.puts "Another program is running on port #{@port}. Set a new port in #{@config_file} for dev_server"
        exit!
      end

      def execute_cmd
        argv = @argv.dup

        # Delete supplied host, port and listen-host CLI arguments
        ["--host", "--port", "--listen-host"].each do |arg|
          argv.delete(args(arg))
          argv.delete(arg)
        end

        env = { "NODE_PATH" => @node_modules_path.shellescape }

        cmd = [
          "#{@node_modules_path}/.bin/webpack-dev-server", "--progress", "--color",
          "--config", @webpack_config,
          "--host", @listen_host_addr,
          "--public", "#{@hostname}:#{@port}",
          "--port", @port.to_s
        ] + argv

        Dir.chdir(@app_path) do
          exec env, *cmd
        end
      end

      def args(key)
        index = @argv.index(key)
        index ? @argv[index + 1] : nil
      end
  end
end
