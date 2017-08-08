require "webpacker/file_loader"

# Singleton registry for accessing the packs path using a generated manifest.
# This allows javascript_pack_tag, stylesheet_pack_tag, asset_pack_path to take a reference to,
# say, "calendar.js" or "calendar.css" and turn it into "/packs/calendar.js" or
# "/packs/calendar.css" in development.
#
# In production mode, it returns compiles files, like
# "/packs/calendar-1016838bab065ae1e314.js" and "/packs/calendar-1016838bab065ae1e314.css",
# for long-term caching.
#
# When the configuration is set to on-demand compilation, with the `compile: true` option in
# the webpacker.yml file, any lookups will be preceeded by a compilation if one is needed.
class Webpacker::Manifest < Webpacker::FileLoader
  class << self
    def file_path
      Webpacker::Configuration.manifest_path
    end

    def lookup(name)
      if Webpacker::Configuration.compile?
        compile_and_find!(name)
      else
        find!(name)
      end
    end

    def lookup_path(name)
      Rails.root.join(File.join(Webpacker::Configuration.public_path, lookup(name)))
    end

    private
      def find!(name)
        ensure_loaded_instance(self)
        instance.data[name.to_s] ||
          raise(Webpacker::FileLoader::NotFoundError.new("Can't find #{name} in #{file_path}. Is webpack still compiling?"))
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
