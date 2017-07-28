# Same convention as manifest/configuration.rb

# Loads webpacker configuration from config/webpacker.yml

require "webpacker/configuration"

class Webpacker::DevServer < Webpacker::FileLoader
  class << self
    def dev_server?
      !dev_server_values.nil?
    end

    # read settings for dev_server
    def hot?
      return false unless dev_server?
      if ENV["WEBPACKER_HMR"].present?
        val = ENV["WEBPACKER_HMR"].downcase
        return true if val == "true"
        return false if val == "false"
        raise new ArgumentError("WEBPACKER_HMR value is #{ENV['WEBPACKER_HMR']}. Set to TRUE|FALSE")
      end
      fetch(:hot)
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

    def file_path
      Webpacker::Configuration.file_path
    end

    # Uses the hot_reloading_host if appropriate
    def base_url
      "#{protocol}://#{host}:#{port}"
    end

    private

    def dev_server_values
      data.fetch(:dev_server, nil)
    end

    def fetch(key)
      return nil unless dev_server?
      dev_server_values.fetch(key, dev_server_defaults[key])
    end

    def data
      load_instance if Webpacker.env.development?
      unless instance
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::DevServer.load_data must be called first")
      end
      instance.data
    end

    def dev_server_defaults
      @defaults ||= Webpacker::Configuration.defaults[:dev_server]
    end
  end

  private
    def load_data
      Webpacker::Configuration.instance.data
    end
end
