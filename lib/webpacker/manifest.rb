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

    # Converts the "name" (aka the pack or bundle name) to to the full path for use in a browser.
    def asset_source(name)
      output_path_or_url = Webpacker::Configuration.output_path_or_url
      mapped_name = lookup(name)
      "#{output_path_or_url}/#{mapped_name}"
    end

    # Converts the "name" (aka the pack or bundle name) to the possibly hashed name per a manifest.
    #
    # If Configuration.compile? then compilation is invoked the file is missing.
    #
    # Options
    # throw_if_missing: default is true. If false, then nill is returned if the file is missing.
    def lookup(name, throw_if_missing: true)
      instance.confirm_manifest_exists

      if Webpacker::Configuration.compile?
        compile_and_find(name, throw_if_missing: throw_if_missing)
      else
        # Since load checks a `mtime` on the manifest for a non-production env before loading,
        # we should always call this before a call to `find!` since one may be using
        # `webpack -w` and a file may have been added to the manifest since Rails first started.
        load
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Manifest.load must be called first") unless instance

        return find(name, throw_if_missing: throw_if_missing)
      end
    end

    # Why does this method exist? Testing? It's not in the README
    def lookup_path(name)
      Rails.root.join(File.join(Webpacker::Configuration.output_path, lookup(name)))
    end

    private
      def missing_file_from_manifest_error(bundle_name)
        msg = <<-MSG
Webpacker can't find #{bundle_name} in your manifest at #{file_path}. Possible causes:
  1. You are hot reloading.
  2. You want to set Configuration.compile to true for your environment.
  3. Webpack has not re-run to reflect updates.
  4. You have misconfigured Webpacker's config/webpacker.yml file.
  5. Your Webpack configuration is not creating a manifest.
Your manifest contains:
#{instance.data.to_json}
        MSG
        raise(Webpacker::FileLoader::NotFoundError.new(msg))
      end

      def missing_manifest_file_error(path_object)
        msg = <<-MSG
Webpacker can't find the manifest file: #{path_object}
Possible causes:
  1. You have not invoked webpack.
  2. You have misconfigured Webpacker's config/webpacker_.yml file.
  3. Your Webpack configuration is not creating a manifest.
MSG
        raise(Webpacker::FileLoader::NotFoundError.new(msg))
      end

      def find(name, throw_if_missing: true)
        value = instance.data[name.to_s]
        return value if value.present?

        if throw_if_missing
          missing_file_from_manifest_error(name)
        end
      end

      def compile_and_find!(name, throw_if_missing: true)
        Webpacker.compile
        find(name, throw_if_missing: throw_if_missing)
      end
  end

  def confirm_manifest_exists
    raise missing_manifest_file_error(@path) unless File.exist?(@path)
  end

  private
    def load
      return super unless File.exist?(@path)
      JSON.parse(File.read(@path))
    end
end
