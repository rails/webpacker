# Singleton registry for determining NODE_ENV from config/webpacker.yml
require "webpacker/file_loader"

class Webpacker::Env < Webpacker::FileLoader
  class << self
    def current
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Env.load must be called first") unless instance
      instance.data
    end

    def file_path
      Rails.root.join("config", "webpacker.yml")
    end
  end

  private
    def load
      environments = File.exist?(@path) ? YAML.load(File.read(@path)).keys : [].freeze
      return ENV["NODE_ENV"] if environments.include?(ENV["NODE_ENV"])
      return Rails.env if environments.include?(Rails.env)
      "production"
    end
end
