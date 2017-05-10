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
      if Webpacker.env.test?
        compile_and_retry_on_error do
          lookup_or_raise(name)
        end
      else
        lookup_or_raise(name)
      end
    end

    def lookup_path(name)
      Rails.root.join(File.join(Webpacker::Configuration.output_path, lookup(name)))
    end

    private
      def lookup_or_raise(name)
        load if Webpacker.env.development?
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Manifest.load must be called first") unless instance
        instance.data[name.to_s] || raise(Webpacker::FileLoader::NotFoundError.new("Can't find #{name} in #{file_path}. Is webpack still compiling?"))
      end

      def compile_and_retry_on_error
        retried = false
        begin
          yield
        rescue
          raise if retried
          retried = true
          Webpacker.compile
          retry
        end
      end
  end

  private
    def load
      return super unless File.exist?(@path)
      JSON.parse(File.read(@path))
    end
end
