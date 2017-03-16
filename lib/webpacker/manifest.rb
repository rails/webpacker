# Singleton registry for accessing the packs path using generated manifest.
# This allows javascript_pack_tag, stylesheet_pack_tag, asset_pack_path to take a reference to,
# say, "calendar.js" or "calendar.css" and turn it into "/packs/calendar.js" or
# "/packs/calendar.css" in development. In production mode, it returns compiles
# files, # "/packs/calendar-1016838bab065ae1e314.js" and
# "/packs/calendar-1016838bab065ae1e314.css" for long-term caching

require "webpacker/file_loader"
require "webpacker/configuration"

class Webpacker::Manifest < Webpacker::FileLoader
  class << self
    def file_path
      Webpacker::Configuration.manifest_path
    end

    def lookup(name)
      load if Rails.env.development?
      raise Webpacker::FileLoader::FileLoaderError.new("Webpacker::Manifest.load must be called first") unless instance
      instance.data[name.to_s] || raise(Webpacker::FileLoader::NotFoundError.new("Can't find #{name} in #{file_path}. Is webpack still compiling?"))
    end
  end

  private
    def load
      begin
        retries ||= 0
        JSON.parse(File.read(@path))
      rescue Errno::ENOENT
        return super unless Rails.env.development?
        Rails.logger.info "Packs manifest not found #{Webpacker::Configuration.manifest_path}, waiting for #{retries + 1}sec before retrying"
        sleep(retries += 1)
        retries < 10 ? retry : super
      end
    end
end
