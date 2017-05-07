require "webpacker_test"

class CheckNodeTest < Minitest::Test
  def setup
    TestApp::Application.load_tasks if Rake::Task.tasks.empty?
  end

  def test_node_old_version
    at_exit do
      Kernel.stub :`, "v6.0.0" do
        assert_output(/Webpacker requires Node.js >= v6.4 and you are using v6.0.0/) do
          Rake::Task["webpacker:check_node"].invoke
        end
      end
      nil
    end
  end

  def test_node_not_installed
    at_exit do
      Kernel.stub :`, nil do
        assert_output(/Node.js not installed. Please download and install Node.js/) do
          Rake::Task["webpacker:check_node"].invoke
        end
      end
      nil
    end
  end
end
