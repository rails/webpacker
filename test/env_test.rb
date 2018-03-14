require "test_helper"

class EnvTest < Webpacker::Test
  def test_current
    reloaded_config
    assert_equal Webpacker.env, "production"
  end

  def test_custom
    with_node_env("default") do
      reloaded_config
      assert_equal Webpacker.env, "default"
    end
  end

  def test_custom_with_user_defined
    with_node_env("cucumber") do
      reloaded_config
      assert_equal Webpacker.env, "cucumber"
    end
  end

  def test_fallback
    with_node_env("not-defined") do
      reloaded_config
      assert_equal Webpacker.env, "production"
    end
  end

  def test_default
    assert_equal Webpacker::Env::DEFAULT, "production"
  end
end
