# Loads webpacker configuration from config/webpack/paths.yml

require "webpacker/file_loader"

class Webpacker::Configuration < Webpacker::FileLoader
  class << self
    def entry_path
      source_path.join(fetch(:entry))
    end

    def output_path
      public_path.join(fetch(:output))
    end

    def manifest_path
      output_path.join(fetch(:manifest))
    end


    def source_path
      Rails.root.join(source)
    end

    def public_path
      Rails.root.join("public")
    end

    def config_path
      Rails.root.join(fetch(:config))
    end


    def file_path(root: Rails.root)
      root.join("config/webpack/paths.yml")
    end

    def default_file_path
      file_path(root: Pathname.new(__dir__).join("../install"))
    end


    def source
      fetch(:source)
    end

    def fetch(key)
      paths.fetch(key, default_paths[key])
    end


    def paths
      load if Webpacker.env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Configuration.load must be called first") unless instance
      instance.data
    end

    def default_paths
      @default_paths ||= HashWithIndifferentAccess.new(YAML.load(default_file_path.read)["default"])
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path))[Webpacker.env])
    end
end
