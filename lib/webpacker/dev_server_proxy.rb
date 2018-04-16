require "rack/proxy"

class Webpacker::DevServerProxy < Rack::Proxy
  def rewrite_response(response)
    _status, headers, _body = response
    headers.delete "transfer-encoding"
    headers.delete "content-length" if Webpacker.dev_server.running? && Webpacker.dev_server.https?
    response
  end

  def perform_request(env)
    if env["PATH_INFO"].start_with?("/#{public_output_uri_path}") && Webpacker.dev_server.running?
      env["HTTP_HOST"] = env["HTTP_X_FORWARDED_HOST"] = env["HTTP_X_FORWARDED_SERVER"] = Webpacker.dev_server.host_with_port
      env["HTTP_X_FORWARDED_PROTO"] = env["HTTP_X_FORWARDED_SCHEME"] = Webpacker.dev_server.protocol
      unless Webpacker.dev_server.https?
        env["HTTPS"] = env["HTTP_X_FORWARDED_SSL"] = "off"
      end
      env["SCRIPT_NAME"] = ""

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
