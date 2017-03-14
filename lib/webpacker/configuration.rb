# Loads webpacker configuration from config/webpack/paths.yml
require "webpacker/file_loader"

class Webpacker::Configuration < Webpacker::FileLoader
  class << self
    def file_path
      Rails.root.join("config", "webpack", "paths.yml")
    end

    def manifest_path
      Rails.root.join(packs_path, "manifest.json")
    end

    def packs_path
      Rails.root.join(paths.fetch(:dist_path, "public/packs"))
    end

    def paths
      load if Rails.env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Configuration.load must be called first") unless instance
      instance.data.fetch(:paths, {})
    end

    def shared_config_path
      Rails.root.join(webpack_config_path, "shared.js")
    end

    def webpack_config_path
      Rails.root.join(paths.fetch(:config_path, "config/webpack"))
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path)))
    end
end
