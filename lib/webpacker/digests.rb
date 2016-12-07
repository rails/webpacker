class Webpacker::Digests
  class_attribute :instance

  class << self
    def load(path)
      self.instance = new(path)
    end

    def lookup(name)
      if instance
        instance.lookup(name)
      else
        raise "Webpacker::Digests.load(path) must be called first"
      end
    end
  end

  def initialize(path)
    @path = path
    load
  end

  def lookup(name)
    @digests[name.to_s]
  end

  private
    def load
      begin
        @digests = JSON.parse(File.read(@path))
      rescue Errno::ENOENT
        Rails.logger.error \
          "Missing digests file at #{@path}! You must first compile the packs via rails webpacker:compile"
      end
    end
end
