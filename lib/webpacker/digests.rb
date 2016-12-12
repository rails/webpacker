# Singleton registry for accessing the digested filenames computed by Webpack in production mode.
# This allows javascript_pack_tag to take a reference to, say, "calendar.js" and turn it into 
# "calendar-1016838bab065ae1e314.js". These digested filenames are what enables you to long-term
# cache things in production.
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
