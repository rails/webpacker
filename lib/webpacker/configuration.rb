# Loads webpacker configuration from config/webpack/configuration.yml

require "webpacker/file_loader"

class Webpacker::Configuration < Webpacker::FileLoader
  class << self
    def config_path
      Rails.root.join(paths.fetch(:config, "config/webpack"))
    end

    def data
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Configuration.load must be called first") unless instance
      instance.data
    end

    def dev_server
      data.fetch(:devServer, {})
    end

    def entry_path
      Rails.root.join(source_path, paths.fetch(:entry, "packs"))
    end

    def file_path
      Rails.root.join("config", "webpack", "configuration.yml")
    end

    def manifest_path
      Rails.root.join(packs_path, paths.fetch(:manifest, "manifest.json"))
    end

    def packs_path
      Rails.root.join(output_path, paths.fetch(:entry, "packs"))
    end

    def paths
      load unless Webpacker.caching
      data.fetch(:paths, {}.freeze)
    end

    def output_path
      Rails.root.join(paths.fetch(:output, "public"))
    end

    def source
      paths.fetch(:source, "app/javascript")
    end

    def source_path
      Rails.root.join(source)
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path))[Webpacker.env])
    end
end
