require "shellwords"
require "yaml"
require "socket"

module Webpacker
  class DevServerRunner
    def self.run(argv)
      $stdout.sync = true

      new(argv).run
    end

    def initialize(argv)
      @argv = argv

      @app_path          = File.expand_path("../", __dir__)
      @config_file       = File.join(@app_path, "config/webpacker.yml")
      @node_modules_path = File.join(@app_path, "node_modules")
      @webpack_config    = File.join(@app_path, "config/webpack/#{ENV["NODE_ENV"]}.js")
      @default_listen_host_addr = ENV["NODE_ENV"] == 'development' ? 'localhost' : '0.0.0.0'

      begin
        dev_server = YAML.load_file(@config_file)[ENV["RAILS_ENV"]]["dev_server"]

        @hostname          = args('--host') || dev_server["host"]
        @port              = args('--port') || dev_server["port"]
        @https             = @argv.include?('--https') || dev_server["https"]
        @dev_server_addr   = "http#{"s" if @https}://#{@hostname}:#{@port}"
        @listen_host_addr  = args('--listen-host') || @default_listen_host_addr

      rescue Errno::ENOENT, NoMethodError
        $stdout.puts "Webpack dev_server configuration not found in #{@config_file}."
        $stdout.puts "Please run bundle exec rails webpacker:install to install webpacker"
        exit!
      end
    end

    def run
      check_server!
      update_argv
      execute_cmd
    end

    private
      def check_server!
        server = TCPServer.new(@listen_host_addr, @port)
        server.close

      rescue Errno::EADDRINUSE
        $stdout.puts "Another program is running on port #{@port}. Set a new port in #{@config_file} for dev_server"
        exit!
      end

      def update_argv
      end

      def execute_cmd
        argv = @argv

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
