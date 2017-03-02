# Singleton registry for accessing the packs path using generated manifest.
# This allows javascript_pack_tag or stylesheet_pack_tag to take a reference to,
# say, "calendar.js" or "calendar.css" and turn it into "/packs/calendar.js" or
# "/packs/calendar.css" in development. In production mode, it returns digested
# files, # "/packs/calendar-1016838bab065ae1e314.js" and
# "/packs/calendar-1016838bab065ae1e314.css" for long-term caching

class Webpacker::Manifest
  class ManifestError < StandardError; end

  class_attribute :instance

  class << self
    def load(path = digests_path)
      self.instance = new(path)
    end

    def lookup(name)
      load if Rails.env.development?

      if instance
        instance.lookup(name).presence || raise(ManifestError.new("Can't find #{name} in #{instance.inspect}. Try reloading in case it's still compiling!"))
      else
        raise ManifestError.new("Webpacker::Manifest.load(path) must be called first")
      end
    end

    def digests_path
      webpacker_config = Webpacker::PackageJson.webpacker
      Rails.root.join(webpacker_config[:distPath], webpacker_config[:digestFileName])
    end
  end

  def lookup(name)
    @digests[name.to_s]
  end

  private

    def initialize(path)
      @path    = path
      @digests = load
    end

    def load
      if File.exist?(@path)
        JSON.parse(File.read(@path))
      else
        Rails.logger.info "Didn't find any digests file at #{@path}. You must first compile the packs via rails webpacker:compile"
        {}
      end
    end
end
