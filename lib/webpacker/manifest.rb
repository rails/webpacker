# Singleton registry for accessing the packs path using generated manifest.
# This allows javascript_pack_tag, stylesheet_pack_tag, asset_pack_path to take a reference to,
# say, "calendar.js" or "calendar.css" and turn it into "/packs/calendar.js" or
# "/packs/calendar.css" in development. In production mode, it returns compiles
# files, # "/packs/calendar-1016838bab065ae1e314.js" and
# "/packs/calendar-1016838bab065ae1e314.css" for long-term caching

require "webpacker/file_loader"

class Webpacker::Manifest < Webpacker::FileLoader
  class << self
    def file_path
      Webpacker::Configuration.manifest_path
    end

    def lookup(name)
      load if Webpacker.env.development?

      if Webpacker.env.test?
        find(name) || compile_and_find!(name)
      else
        find!(name)
      end
    end

    def lookup_path(name)
      Rails.root.join(File.join(Webpacker::Configuration.public_path, lookup(name)))
    end

    private
      def find(name)
        instance.data[name.to_s] if instance
      end

      def find!(name)
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Manifest.load must be called first") unless instance
        instance.data[name.to_s] || raise(Webpacker::FileLoader::NotFoundError.new("Can't find #{name} in #{file_path}. Is webpack still compiling?"))
      end

      def compile_and_find!(name)
        Webpacker.compile
        find!(name)
      end
  end

  private
    def load
      return super unless File.exist?(@path)
      JSON.parse(File.read(@path))
    end
end
