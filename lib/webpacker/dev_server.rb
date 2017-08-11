module Webpacker::DevServer
  extend self

  def running?
    socket = Socket.tcp(host, port, connect_timeout: 1)
    socket.close
    true

  rescue Errno::ECONNREFUSED, NoMethodError
    false
  end

  def hmr?
    case ENV["WEBPACKER_HMR"]
    when /true/i then true
    when /false/i then false
    else fetch(:hmr)
    end

  rescue NoMethodError
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

  def base_url
    "#{protocol}://#{host}:#{port}"
  end

  def fetch(key)
    Webpacker::Configuration.data[:dev_server][key] || Webpacker::Configuration.defaults[:dev_server][key]
  end
end
