require "rack/proxy"

class Webpacker::DevServerProxy < Rack::Proxy
  def rewrite_response(response)
    status, headers, body = response
    headers.delete "transfer-encoding"
    headers.delete "content-length"
    response
  end

  def perform_request(env)
      env["HTTP_HOST"] = "#{Webpacker.dev_server.host}:#{Webpacker.dev_server.port}"
    if env["PATH_INFO"] =~ /#{public_output_uri_path}/ && Webpacker.dev_server.running?
      super(env)
    else
      @app.call(env)
    end
  end

  private
    def public_output_uri_path
      Webpacker.config.public_output_path.relative_path_from(Webpacker.config.public_path)
    end
end
