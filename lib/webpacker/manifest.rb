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

    # Throws an error if the file is not found. If Configuration.compile? then compilation is invoked
    # the file is missing.
    # React on Rails users will need to set Configuration.compile? to false as compilation is configured
    # in the package.json for React on Rails.
    def lookup(name)
      if Webpacker::Configuration.compile?
        compile_and_find!(name)
      else
        find!(name)
      end
    end

    # Why does this method exist? Testing? It's not in the README
    def lookup_path(name)
      Rails.root.join(File.join(Webpacker::Configuration.output_path, lookup(name)))
    end

    # Helper method to determine if the manifest file exists. Maybe Webpack needs to run?
    # **Used by React on Rails.**
    def exist?
      path_object = Webpacker::Configuration.manifest_path
      path_object.exist?
    end

    # Find the real file name from the manifest key. Don't throw an error if the file is simply
    # missing from the manifest. Return nil in that case.
    # If no manifest file exists, then throw an error.
    # **Used by React on Rails.**
    def lookup_path_no_throw(name)
      instance.confirm_manifest_exists
      load_instance
      unless instance
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Manifest.load must be called first")
      end
      hashed_name = instance.data[name.to_s]
      return hashed_name if hashed_name.blank?
      Rails.root.join(File.join(Webpacker::Configuration.output_path, hashed_name))
    end

    private
    def find!(name)
      unless instance
        raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Manifest.load must be called first")
      end
      instance.data[name.to_s] || missing_file_from_manifest_error(name)
    end

    def missing_file_from_manifest_error(bundle_name)
      msg = <<-MSG
        Webpacker can't find #{bundle_name} in your manifest at #{file_path}. Possible causes:
          1. You are hot reloading.
          2. You want to set Configuration.compile to true for your environment.
          3. Webpack has not re-run to reflect updates.
          4. You have misconfigured Webpacker's config/webpacker.yml file.
          5. Your Webpack configuration is not creating a manifest.
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

    def compile_and_find!(name)
      Webpacker.compile
      find!(name)
    end
  end

  def confirm_manifest_exists
    raise missing_manifest_file_error(@path) unless File.exist?(@path)
  end

  private

    def load_data
      return super unless File.exist?(@path)
      JSON.parse(File.read(@path))
    end
end
