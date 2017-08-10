# Singleton registry for determining NODE_ENV from config/webpacker.yml
require "webpacker/file_loader"

class Webpacker::Env < Webpacker::FileLoader
  DEFAULT = "production"

  class << self
    def current
      ensure_loaded_instance(self)
      instance.data.inquiry
    end

    def file_path
      Rails.root.join("config", "webpacker.yml")
    end
  end

  private
    def load
      ENV["NODE_ENV"].presence_in(available_environments) || Rails.env.presence_in(available_environments) || DEFAULT
    end

    def available_environments
      File.exist?(@path) ? YAML.load(File.read(@path)).keys : [].freeze
    end
end
