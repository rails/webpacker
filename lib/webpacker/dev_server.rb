# Loads webpacker configuration from config/webpack/development.server.yml
require "webpacker/file_loader"
require "webpacker/env"

class Webpacker::DevServer < Webpacker::FileLoader
  class << self
    def file_path
      Rails.root.join("config", "webpack", "development.server.yml")
    end

    def settings
      load if Webpacker::Env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Configuration.DevServer must be called first") unless instance
      instance.data
    end

    def hot?
      Webpacker::Env.development? && settings.fetch(:hot, true)
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path))[Webpacker::Env.current])
    end
end
