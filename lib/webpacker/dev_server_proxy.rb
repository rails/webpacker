require "rack/proxy"

class Webpacker::DevServerProxy < Rack::Proxy
  def rewrite_response(response)
    status, headers, body = response
    headers.delete "transfer-encoding"
    headers.delete "content-length"
    response
  end

  def perform_request(env)
    if env["PATH_INFO"] =~ /#{Webpacker.config.public_output_dir}/
      env["HTTP_HOST"] = "#{Webpacker.dev_server.host}:#{Webpacker.dev_server.port}"
      super(env)
    else
      @app.call(env)
    end
  end
end
