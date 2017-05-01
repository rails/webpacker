require "webpacker_test"

class EnvTest < Minitest::Test
  def test_current_env
    assert_equal Webpacker::Env.current, "production"
  end

  def test_env_is_development?
    refute_predicate Webpacker::Env, :development?
  end

  def test_file_path
    correct_path = File.join(File.dirname(__FILE__), "test_app/config", "webpack", "paths.yml").to_s
    assert_equal Webpacker::Env.file_path.to_s, correct_path
  end
end
