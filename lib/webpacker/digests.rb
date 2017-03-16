# Singleton registry for accessing the digested filenames computed by Webpack in production mode.
# This allows javascript_pack_tag to take a reference to, say, "calendar.js" and turn it into 
# "calendar-1016838bab065ae1e314.js". These digested filenames are what enables you to long-term
# cache things in production.
class Webpacker::Digests
  class DigestError < StandardError; end

  class_attribute :instance

  class << self
    def load(path)
      self.instance = new(path)
    end

    def lookup(name)
      if instance
        instance.lookup(name).presence || raise(DigestError.new("Can't find #{name} in #{instance.inspect}"))
      else
        raise DigestError.new("Webpacker::Digests.load(path) must be called first")
      end
    end
  end

  def initialize(path)
    @path    = path
    @digests = load
  end

  def lookup(name)
    lookedup = @digests[name.to_s]
    if lookedup.respond_to?(:select)
      lookedup.select { |fn| fn.end_with?('.js') }.first
    else
      lookedup
    end
  end

  private
    def load
      if File.exist?(@path)
        JSON.parse(File.read(@path))
      else
        Rails.logger.info "Didn't find any digests file at #{@path}. You must first compile the packs via rails webpacker:compile"
        {}
      end
    end
end
