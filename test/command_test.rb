require "test_helper"

class CommandTest < Minitest::Test
  def test_compile_command_returns_success_status_when_stale
    Webpacker.compiler.stub :stale?, true do
      Webpacker.compiler.stub :run_webpack, true do
        assert_equal true, Webpacker.commands.compile
      end
    end
  end

  def test_compile_command_returns_success_status_when_fresh
    Webpacker.compiler.stub :stale?, false do
      Webpacker.compiler.stub :run_webpack, true do
        assert_equal true, Webpacker.commands.compile
      end
    end
  end

  def test_compile_command_returns_failure_status_when_stale
    Webpacker.compiler.stub :stale?, true do
      Webpacker.compiler.stub :run_webpack, false do
        assert_equal false, Webpacker.commands.compile
      end
    end
  end

  def test_clean_command_works_with_nested_hashes_and_without_any_compiled_files
    File.stub :delete, true do
      assert Webpacker.commands.clean
    end
  end
end

class ClearCommandVersioningTest < Minitest::Test
  def setup
    @now = Time.parse("2021-01-01 12:34:56 UTC")
    # Test assets to be kept and deleted, path and mtime
    @prev_files = {
      # recent versions to be kept with Webpacker.commands.clean(count = 2)
      "js/application-deadbeef.js" => @now - 4000,
      "js/common-deadbeee.js" => @now - 4002,
      "css/common-deadbeed.css" => @now - 4004,
      "media/images/logo-deadbeeb.css" => @now - 4006,
      "js/application-1eadbeef.js" => @now - 8000,
      "js/common-1eadbeee.js" => @now - 8002,
      "css/common-1eadbeed.css" => @now - 8004,
      "media/images/logo-1eadbeeb.css" => @now - 8006,
      # new files to be kept with Webpacker.commands.clean(age = 3600)
      "js/brandnew-0001.js" => @now,
      "js/brandnew-0002.js" => @now - 10,
      "js/brandnew-0003.js" => @now - 20,
      "js/brandnew-0004.js" => @now - 40,
    }.transform_keys { |path| "#{Webpacker.config.public_output_path}/#{path}" }
    @expired_files = {
      # old files that are outside count = 2 or age = 3600 and to be deleted
      "js/application-0eadbeef.js" => @now - 9000,
      "js/common-0eadbeee.js" => @now - 9002,
      "css/common-0eadbeed.css" => @now - 9004,
      "js/brandnew-0005.js" => @now - 3640,
    }.transform_keys { |path| "#{Webpacker.config.public_output_path}/#{path}" }
    @all_files = @prev_files.merge(@expired_files)
    @dir_glob_stub = Proc.new { |arg|
      case arg
      when "#{Webpacker.config.public_output_path}/**/*"
        @all_files.keys
      else
        []
      end
    }
    @file_mtime_stub = Proc.new { |longpath|
      @all_files[longpath]
    }
    @file_delete_mock = Minitest::Mock.new
    @expired_files.keys.each do |longpath|
      @file_delete_mock.expect(:delete, 1, [longpath])
    end
    @file_delete_stub = Proc.new { |longpath|
      if @prev_files.has_key?(longpath)
        flunk "#{longpath} should not be deleted"
      else
        @file_delete_mock.delete(longpath)
      end
    }
  end

  def time_and_files_stub(&proc)
    Time.stub :now, @now do
      Dir.stub :glob, @dir_glob_stub do
        File.stub :directory?, false do
          File.stub :file?, true do
            File.stub :mtime, @file_mtime_stub do
              File.stub :delete, @file_delete_stub do
                yield proc
              end
            end
          end
        end
      end
    end
    @file_delete_mock.verify
  end

  def test_clean_command_with_versioned_files
    time_and_files_stub do
      assert Webpacker.commands.clean
    end
  end
end
