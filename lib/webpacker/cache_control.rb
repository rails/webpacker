class Webpacker::CacheControl
  ALLOWED_REQUEST_METHODS = ["GET", "HEAD"].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ /#{public_output_uri_path}/
      status, headers, body = @app.call(env)

      unless ALLOWED_REQUEST_METHODS.include?(env["REQUEST_METHOD"])
        return method_not_allowed_response
      end

      etag, new_body = Rack::ETag.new(env).send(:digest_body, body)

      # Set caching headers
      headers["Cache-Control"] = String.new("public")
      headers["ETag"]          = %("#{etag}")

      # If the request url contains a fingerprint, set a long
      # expires on the response
      if path_fingerprint(env["PATH_INFO"])
        headers["Cache-Control"] << ", max-age=31536000, immutable"

      # Otherwise set `must-revalidate` since the asset could be modified.
      else
        headers["Cache-Control"] << ", must-revalidate"
        headers["Vary"] = "Accept-Encoding"
      end

      [status, headers, new_body]
    else
      @app.call(env)
    end
  end

  private
    def public_output_uri_path
      Webpacker.config.public_output_path.relative_path_from(Webpacker.config.public_path)
    end

    def method_not_allowed_response
      [ 405, { "Content-Type" => "text/plain", "Content-Length" => "18" }, [ "Method Not Allowed" ] ]
    end

    def path_fingerprint(path)
      path[/-([0-9a-f]{7,128})\.[^.]+\z/, 1]
    end
end
