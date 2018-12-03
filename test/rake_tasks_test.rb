require "test_helper"

class RakeTasksTest < Minitest::Test
  def test_rake_tasks
    output = Dir.chdir(test_app_path) { `rake -T` }
    assert_includes output, "webpacker"
    assert_includes output, "webpacker:check_binstubs"
    assert_includes output, "webpacker:check_node"
    assert_includes output, "webpacker:check_yarn"
    assert_includes output, "webpacker:clobber"
    assert_includes output, "webpacker:compile"
    assert_includes output, "webpacker:install"
    assert_includes output, "webpacker:install:angular"
    assert_includes output, "webpacker:install:elm"
    assert_includes output, "webpacker:install:react"
    assert_includes output, "webpacker:install:vue"
    assert_includes output, "webpacker:verify_install"
  end

  def test_rake_task_webpacker_check_binstubs
    output = Dir.chdir(test_app_path) { `rake webpacker:check_binstubs 2>&1` }
    refute_includes output, "webpack binstubs not found."
  end

  def test_rake_webpacker_yarn_install_in_non_production_environments
    assert_includes test_app_dev_dependencies, "right-pad"

    Webpacker.with_node_env("test") do
      Dir.chdir(test_app_path) do
        `bundle exec rake webpacker:yarn_install`
      end
    end

    assert_includes installed_node_module_names, "right-pad",
                    "Expected dev dependencies to be installed"
  end

  def test_rake_webpacker_yarn_install_in_production_environment
    Webpacker.with_node_env("production") do
      Dir.chdir(test_app_path) do
        `bundle exec rake webpacker:yarn_install`
      end
    end

    refute_includes installed_node_module_names, "right-pad",
                    "Expected only production dependencies to be installed"
  end

  private
    def test_app_path
      File.expand_path("test_app", __dir__)
    end

    def test_app_dev_dependencies
      package_json = File.expand_path("package.json", test_app_path)
      JSON.parse(File.read(package_json))["devDependencies"]
    end

    def installed_node_module_names
      node_modules_path = File.expand_path("node_modules", test_app_path)
      Dir.chdir(node_modules_path) { Dir.glob("*") }
    end
end
