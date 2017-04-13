require 'webpacker_test'

class EnvTest < Minitest::Test
  def setup
    @env = Webpacker::Env.current
  end

  def test_current_env
    assert @env == "production"
  end

  def test_env_is_development?
    assert @env != "development"
  end
end
