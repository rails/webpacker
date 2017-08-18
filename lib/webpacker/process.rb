require "rack/server"

class Webpacker::Process < ::Rack::Server
  def start
    puts "Starting #{Webpacker.config.compiler}"
    system(Webpacker.config.compiler)
    super

  ensure
    puts "Exiting #{Webpacker.config.compiler}"
  end
end
