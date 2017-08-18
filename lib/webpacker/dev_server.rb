class Webpacker::DevServer
  delegate :config, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def running?
    Socket.tcp(host, port, connect_timeout: 1).close
    true
  rescue Errno::ECONNREFUSED, NoMethodError
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
