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

  def test_default
    assert_equal Webpacker::Env::DEFAULT, "production"
  end
end
