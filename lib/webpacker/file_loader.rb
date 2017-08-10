# Provides a base singleton-configuration pattern for loading a file, given a path
class Webpacker::FileLoader
  class NotFoundError < StandardError; end
  class FileLoaderError < StandardError; end

  class_attribute :instance
  attr_accessor :data, :mtime, :path

  class << self
    def load(path = file_path)
      if instance.nil? || !production_env? || !file_cached?(path)
        self.instance = new(path)
      end
    end

    def file_path
      raise FileLoaderError.new("Subclass of Webpacker::FileLoader should override this method")
    end

    private
      def file_cached?(path)
        File.exist?(path) && self.instance.mtime == File.mtime(path)
      end

      # Prefer the NODE_ENV to the rails env.
      def production_env?
        (ENV["NODE_ENV"].presence || Rails.env) == "production"
      end

    protected
      def ensure_loaded_instance(klass)
        raise Webpacker::FileLoader::FileLoaderError.new("#{klass.name}#load must be called first") unless instance
      end
  end

  private
    def initialize(path)
      @path = path
      @mtime = File.exist?(path) ? File.mtime(path) : nil
      @data = load
    end

    def load
      {}.freeze
    end
end
