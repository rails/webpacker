class Webpacker::DevServer
  DEFAULT_ENV_PREFIX = "WEBPACKER_DEV_SERVER".freeze

  # Configure dev server connection timeout (in seconds), default: 0.01
  # Webpacker.dev_server.connect_timeout = 1
  cattr_accessor(:connect_timeout) { 0.01 }
  # Dev server connection checking frequency, default: 1 second
  # Webpacker.dev_server.connection_check_frequency = 1
  cattr_accessor(:connection_check_frequency) { 1 }

  attr_reader :config

  def initialize(config)
    @config = config
  end

  def running?
    monitor.running?
  end

  def host
    fetch(:host)
  end

  def port
    fetch(:port)
  end

  def https?
    case fetch(:https)
    when true, "true", Hash
      true
    else
      false
    end
  end

  def protocol
    https? ? "https" : "http"
  end

  def host_with_port
    "#{host}:#{port}"
  end

  def pretty?
    fetch(:pretty)
  end

  def env_prefix
    config.dev_server.fetch(:env_prefix, DEFAULT_ENV_PREFIX)
  end

  private

    def monitor
      @monitor ||= Webpacker::DevServerMonitor.new
    end

    def fetch(key)
      ENV["#{env_prefix}_#{key.upcase}"] || config.dev_server.fetch(key, defaults[key])
    end

    def defaults
      config.send(:defaults)[:dev_server] || {}
    end
end
