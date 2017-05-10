# Provides a base singleton-configuration pattern for loading a file, given a path
class Webpacker::FileLoader
  class NotFoundError < StandardError; end
  class FileLoaderError < StandardError; end

  class_attribute :instance
  attr_accessor :data

  class << self
    def load(path = file_path)
      self.instance = new(path)
    end
  end

  private
    def initialize(path)
      @path = path
      @data = load
    end

    def load
      {}.freeze
    end
end
