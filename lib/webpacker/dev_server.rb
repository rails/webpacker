# Loads webpack-dev-server configuration from config/webpack/dev_server.yml
require "webpacker/configuration"
require "webpacker/file_loader"

class Webpacker::DevServer < Webpacker::FileLoader
  class << self
    def dev_server
      load if Rails.env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::DevServer.load must be called first") unless instance
      instance.data.fetch(:dev_server, {})
    end

    def file_path
      Rails.root.join(Webpacker::Configuration.webpack_config_path, "dev_server.yml")
    end

    def resolve(filename)
      "http://#{dev_server.fetch(:host, 'localhost')}:#{dev_server.fetch(:port, 8080)}/#{filename}"
    end

    def running?
      return false unless Rails.env.development?
      dev_server.fetch(:enabled, true)
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path)))
    end
end
