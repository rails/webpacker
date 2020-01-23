require "rack/proxy"

class Webpacker::DevServerProxy < Rack::Proxy
  delegate :config, :dev_server, to: :@webpacker

  def initialize(app = nil, opts = {})
    @webpacker = opts.delete(:webpacker) || Webpacker.instance
    opts[:streaming] = false if Rails.env.test? && !opts.key?(:streaming)
    super
  end

  def perform_request(env)
    if env["PATH_INFO"].start_with?("/#{public_output_uri_path}") && dev_server.running?
      env["HTTP_HOST"] = env["HTTP_X_FORWARDED_HOST"] = env["HTTP_X_FORWARDED_SERVER"] = dev_server.host_with_port
      env["HTTP_X_FORWARDED_PROTO"] = env["HTTP_X_FORWARDED_SCHEME"] = dev_server.protocol
      unless dev_server.https?
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
      config.public_output_path.relative_path_from(config.public_path).to_s + "/"
    end
end
