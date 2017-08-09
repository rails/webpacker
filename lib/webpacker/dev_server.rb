# Same convention as manifest/configuration.rb

# Loads webpacker configuration from config/webpacker.yml

require "webpacker/configuration"

class Webpacker::DevServer < Webpacker::FileLoader
  class << self
    def enabled?
      case ENV["WEBPACKER_DEV_SERVER"]
      when /true/i then true
      when /false/i then false
      else !data[:dev_server].nil?
      end
    end

    # read settings for dev_server
    def hot_reloading?
      if enabled?
        case ENV["WEBPACKER_HMR"]
        when /true/i then true
        when /false/i then false
        else fetch(:hot_reloading)
        end
      else
        false
      end
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
      def fetch(key)
        if enabled?
          data[:dev_server][key] || Webpacker::Configuration.defaults[:dev_server][key]
        end
      end

      def data
        load if Webpacker.env.development?
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::DevServer.load must be called first") unless instance
        instance.data
      end
  end

  private
    def load
      Webpacker::Configuration.instance.data
    end
end
