# Same convention as manifest/configuration.rb
# Loads webpacker configuration from config/webpacker.yml

class Webpacker::DevServer < Webpacker::Configuration
  class << self
    def enabled?
      case ENV["WEBPACKER_DEV_SERVER"]
      when /true/i then true
      when /false/i then false
      else !data[:dev_server].nil?
      end
    end

    # read settings for dev_server
    def hmr?
      if enabled?
        case ENV["WEBPACKER_HMR"]
        when /true/i then true
        when /false/i then false
        else fetch(:hmr)
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

    # Uses the hot_reloading_host if appropriate
    def base_url
      "#{protocol}://#{host}:#{port}"
    end

    def fetch(key)
      if enabled?
        data[:dev_server][key] || defaults[:dev_server][key]
      end
    end
  end
end
