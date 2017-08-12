class Webpacker::DevServer
  delegate :dev_server, to: :@webpacker

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

  def hmr?
    dev_server[:hmr]
  end

  def host
    dev_server[:host]
  end

  def port
    dev_server[:port]
  end

  def https?
    dev_server[:https]
  end

  def protocol
    https? ? "https" : "http"
  end
end
