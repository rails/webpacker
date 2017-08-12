class Webpacker::DevServer
  delegate :config, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def running?
    socket = Socket.tcp(host, port, connect_timeout: 1)
    socket.close
    true

  rescue Errno::ECONNREFUSED, NoMethodError
    false
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

  private
    def fetch(key)
      config.dev_server[key]
    end
end
