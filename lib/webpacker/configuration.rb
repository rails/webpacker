# Loads webpacker configuration from config/webpacker.yml

require "webpacker/file_loader"

class Webpacker::Configuration < Webpacker::FileLoader
  class << self
    def entry_path
      source_path.join(paths[:entry])
    end

    def output_path
      public_path.join(paths[:output])
    end

    def manifest_path
      output_path.join(paths[:manifest])
    end

    def source_path
      Rails.root.join(source)
    end

    def public_path
      Rails.root.join("public")
    end

    def config_path
      Rails.root.join(paths[:config])
    end

    def file_path(root: Rails.root)
      root.join("config/webpacker.yml")
    end

    def default_file_path
      file_path(root: Pathname.new(__dir__).join("../install"))
    end

    def source
      paths[:source]
    end

    def data
      load if Webpacker.env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Configuration.load must be called first") unless instance
      instance.data
    end

    def paths
      data.fetch(:paths, default_settings(key: "paths"))
    end

    def dev_server
      data.fetch(:devServer, default_settings(key: "devServer"))
    end

    def default_settings(key: "paths")
      @default_settings ||= HashWithIndifferentAccess.new(YAML.load(default_file_path.read)["default"][key])
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      HashWithIndifferentAccess.new(YAML.load(File.read(@path))[Webpacker.env])
    end
end
