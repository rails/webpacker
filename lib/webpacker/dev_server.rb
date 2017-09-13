class Webpacker::DevServer
  # Configure dev server connection timeout (in seconds), default: 0.01
  # Webpacker.dev_server.connect_timeout = 1
  mattr_accessor(:connect_timeout) { 0.01 }

  delegate :config, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def running?
    Socket.tcp(host, port, connect_timeout: connect_timeout).close
    true
  rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, NoMethodError
    false
  end

  def hot_module_replacing?
    fetch(:hmr)
  end

  def host
    fetch(:host)
  end

  def port
    fetch(:port)
  end

  def https?
    fetch(:https)
  end

  def protocol
    https? ? "https" : "http"
  end

  def host_with_port
    "#{host}:#{port}"
  end

  private
    def fetch(key)
      config.dev_server.fetch(key, defaults[key])
    end

    def defaults
      config.send(:defaults)[:dev_server]
    end
end
