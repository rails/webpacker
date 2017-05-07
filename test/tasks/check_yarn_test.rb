require "webpacker_test"

class CheckYarnTest < Minitest::Test
  def setup
    TestApp::Application.load_tasks if Rake::Task.tasks.empty?
  end

  def test_yarn_install
    at_exit do
      Kernel.stub :`, nil do
        assert_output(/Webpacker requires yarn. Please download and install Yarn/) do
          Rake::Task["webpacker:check_yarn"].invoke
        end
      end
      nil
    end
  end
end
