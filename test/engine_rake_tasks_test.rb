require "test_helper"

class EngineRakeTasksTest < Minitest::Test
  def setup
    remove_webpack_binstubs
  end

  def teardown
    remove_webpack_binstubs
  end

  def test_task_mounted
    output = Dir.chdir(mounted_app_path) { `rake -T` }
    assert_includes output, "app:webpacker"
  end

  def test_binstubs
    Dir.chdir(mounted_app_path) { `bundle exec rake app:webpacker:binstubs` }
    webpack_binstub_paths.each { |path| assert File.exist?(path) }
  end

  private
    def mounted_app_path
      File.expand_path("mounted_app", __dir__)
    end

    def webpack_binstub_paths
      [
        "#{mounted_app_path}/test/dummy/bin/webpack",
        "#{mounted_app_path}/test/dummy/bin/webpack-dev-server",
      ]
    end

    def remove_webpack_binstubs
      webpack_binstub_paths.each do |path|
        File.delete(path) if File.exist?(path)
      end
    end
end
