class Webpacker::DevServer
  DEFAULT_ENV_PREFIX = "WEBPACKER_DEV_SERVER".freeze

  # Configure dev server connection timeout (in seconds), default: 0.01
  # Webpacker.dev_server.connect_timeout = 1
  cattr_accessor(:connect_timeout) { 0.01 }
  # Dev server connection rechecking frequency, default: 10 seconds
  # Webpacker.dev_server.retry_after = 60
  cattr_accessor(:retry_after) { 10 }

  attr_reader :config

  def initialize(config)
    @config = config
  end

  def running?
    if config.dev_server.present?
      check_connection
    else
      false
    end
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
    def check_connection
      now = Time.now
      @last_connect_failure ||= now - retry_after
      return false if @last_connect_failure + retry_after > now

      Socket.tcp(host, port, connect_timeout: connect_timeout).close
      true
    rescue StandardError
      @last_connect_failure = Time.now
      false
    end

    def fetch(key)
      ENV["#{env_prefix}_#{key.upcase}"] || config.dev_server.fetch(key, defaults[key])
    end

    def defaults
      config.send(:defaults)[:dev_server] || {}
    end
end
