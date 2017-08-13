module ReloadConfigHelper
  def reloaded_config
    Webpacker.instance.instance_variable_set(:@config, nil)
    Webpacker.config
  end

  def with_node_env(env)
    original = ENV["NODE_ENV"]
    ENV["NODE_ENV"] = env
    yield
  ensure
    ENV["NODE_ENV"] = original
  end
end
