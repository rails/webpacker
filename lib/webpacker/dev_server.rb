# Same convention as manifest/configuration.rb

# Loads webpacker configuration from config/webpacker.yml

require "webpacker/configuration"

class Webpacker::DevServer < Webpacker::FileLoader
  class << self
    def dev_server?
      env_val = env_value("WEBPACKER_DEV_SERVER")

      # override dev_server setup WEBPACKER_DEV_SERVER=FALSE
      return false if env_val == false

      # If not specified, then check if values in the config file for the dev_server key
      !dev_server_values.nil?
    end

    # read settings for dev_server
    def hot?
      return false unless dev_server?
      env_val = env_value("WEBPACKER_HMR")
      return env_val unless env_val.nil?
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

    def env_value(env_key)
      if ENV[env_key].present?
        val = ENV[env_key]
        val_upcase = val.upcase
        return true if val_upcase == "TRUE"
        return false if val_upcase == "FALSE"
        raise new ArgumentError("#{env_key} value is #{val}. Set to TRUE|FALSE")
      end
      # returns nil
    end

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
