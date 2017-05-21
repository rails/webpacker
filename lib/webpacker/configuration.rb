# Loads webpacker configuration from config/webpacker.yml

require "webpacker/file_loader"

class Webpacker::Configuration < Webpacker::FileLoader
  class << self
    def entry_path
      source_path.join(fetch(:source_entry_path))
    end

    def output_path
      public_path.join(fetch(:public_output_path))
    end

    def manifest_path
      output_path.join("manifest.json")
    end

    def source_path
      Rails.root.join(source)
    end

    def public_path
      Rails.root.join("public")
    end

    def file_path(root: Rails.root)
      root.join("config/webpacker.yml")
    end

    def default_file_path
      file_path(root: Pathname.new(__dir__).join("../install"))
    end

    def source
      fetch(:source_path)
    end

    def fetch(key)
      data.fetch(key, defaults[key])
    end

    def data
      load if Webpacker.env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Configuration.load must be called first") unless instance
      instance.data
    end

    def defaults
      @defaults ||= HashWithIndifferentAccess.new(YAML.load(default_file_path.read)["default"])
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path))[Webpacker.env])
    end
end
