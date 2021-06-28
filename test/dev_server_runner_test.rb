require "test_helper"
require "webpacker/dev_server_runner"

class DevServerRunnerTest < Webpacker::Test
  def setup
    @original_node_env, ENV["NODE_ENV"] = ENV["NODE_ENV"], "development"
    @original_rails_env, ENV["RAILS_ENV"] = ENV["RAILS_ENV"], "development"
    @original_webpacker_config = ENV["WEBPACKER_CONFIG"]
  end

  def teardown
    ENV["NODE_ENV"] = @original_node_env
    ENV["RAILS_ENV"] = @original_rails_env
    ENV["WEBPACKER_CONFIG"] = @original_webpacker_config
  end

  def test_run_cmd_via_node_modules
    cmd = ["#{test_app_path}/node_modules/.bin/webpack", "serve", "--config", "#{test_app_path}/config/webpack/development.js"]

    verify_command(cmd, use_node_modules: true)
  end

  def test_run_cmd_via_yarn
    cmd = ["yarn", "webpack", "serve", "--config", "#{test_app_path}/config/webpack/development.js"]

    verify_command(cmd, use_node_modules: false)
  end

  def test_run_cmd_argv
    cmd = ["#{test_app_path}/node_modules/.bin/webpack", "serve", "--config", "#{test_app_path}/config/webpack/development.js", "--quiet"]

    verify_command(cmd, argv: ["--quiet"])
  end

  def test_run_cmd_argv_with_https
    cmd = ["#{test_app_path}/node_modules/.bin/webpack", "serve", "--config", "#{test_app_path}/config/webpack/development.js", "--https"]

    dev_server = Webpacker::DevServer.new({})
    def dev_server.host; "localhost"; end
    def dev_server.port; "3035"; end
    def dev_server.pretty?; false; end
    def dev_server.https?; true; end
    def dev_server.hmr?; false; end
    Webpacker::DevServer.stub(:new, dev_server) do
      verify_command(cmd, argv: ["--https"])
    end
  end

  def test_environment_variables
    cmd = ["#{test_app_path}/node_modules/.bin/webpack", "serve", "--config", "#{test_app_path}/config/webpack/development.js"]
    env = Webpacker::Compiler.env.dup
    ENV["WEBPACKER_CONFIG"] = env["WEBPACKER_CONFIG"] = "#{test_app_path}/config/webpacker_other_location.yml"
    env["WEBPACK_DEV_SERVER"] = "true"
    verify_command(cmd, env: env)
  end

  private
    def test_app_path
      File.expand_path("test_app", __dir__)
    end

    def verify_command(cmd, use_node_modules: true, argv: [], env: Webpacker::Compiler.env)
      cwd = Dir.pwd
      Dir.chdir(test_app_path)

      klass = Webpacker::DevServerRunner
      instance = klass.new(argv)
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [env, *cmd])

      klass.stub(:new, instance) do
        instance.stub(:node_modules_bin_exist?, use_node_modules) do
          Kernel.stub(:exec, mock) { klass.run(argv) }
        end
      end

      mock.verify
    ensure
      Dir.chdir(cwd)
    end
end
