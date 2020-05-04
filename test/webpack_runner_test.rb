require "test_helper"
require "webpacker/webpack_runner"

class WebpackRunnerTest < Webpacker::Test
  def setup
    @original_node_env, ENV["NODE_ENV"] = ENV["NODE_ENV"], "development"
    @original_rails_env, ENV["RAILS_ENV"] = ENV["RAILS_ENV"], "development"
  end

  def teardown
    ENV["NODE_ENV"] = @original_node_env
    ENV["RAILS_ENV"] = @original_rails_env
  end

  def test_run_cmd_via_node_modules
    cmd = ["#{test_app_path}/node_modules/.bin/webpack", "--config", "#{test_app_path}/config/webpack/development.js"]

    verify_command(cmd, use_node_modules: true)
  end

  def test_run_cmd_via_yarn
    cmd = ["yarn", "webpack", "--config", "#{test_app_path}/config/webpack/development.js"]

    verify_command(cmd, use_node_modules: false)
  end

  private
    def test_app_path
      File.expand_path("test_app", __dir__)
    end

    def verify_command(cmd, use_node_modules: true)
      cwd = Dir.pwd
      Dir.chdir(test_app_path)

      klass = Webpacker::WebpackRunner
      instance = klass.new([])
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [Webpacker::Compiler.env, *cmd])

      klass.stub(:new, instance) do
        instance.stub(:node_modules_bin_exist?, use_node_modules) do
          Kernel.stub(:exec, mock) { klass.run([]) }
        end
      end

      mock.verify
    ensure
      Dir.chdir(cwd)
    end
end
