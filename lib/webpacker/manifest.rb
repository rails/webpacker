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
class Webpacker::Manifest
  class MissingEntryError < StandardError; end

  delegate :config, :compiler, :env, :dev_server, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def refresh
    @data = load
  end

  def lookup(name)
    compile if compiling?
    find name
  end

  private
    def compiling?
      config.compile? && !dev_server.running?
    end

    def compile
      Webpacker.logger.tagged("Webpacker") { compiler.compile }
    end

    def find(name)
      data[name.to_s] || handle_missing_entry(name)
    end

    def handle_missing_entry(name)
      raise Webpacker::Manifest::MissingEntryError,
        "Can't find #{name} in #{config.public_manifest_path}. Manifest contains: #{@data}"
    end

    def missing_file_from_manifest_error(bundle_name)
      msg = <<-MSG
Webpacker can't find #{bundle_name} in #{config.public_manifest_path}. Possible causes:
1. You are hot reloading.
2. You want to set Configuration.compile to true for your environment.
3. Webpack has not re-run to reflect updates.
4. You have misconfigured Webpacker's config/webpacker.yml file.
5. Your Webpack configuration is not creating a manifest.
Your manifest contains:
#{@data.to_json}
    MSG
      raise(Webpacker::FileLoader::NotFoundError.new(msg))
    end

    def data
      if env.production?
        @data ||= load
      else
        refresh
      end
    end

    def load
      if config.public_manifest_path.exist? &&
        (@parsed_mtime.nil? ||
          ((manifest_mtime = File.mtime(config.public_manifest_path)) > @parsed_mtime))
        @parsed_mtime = manifest_mtime
        JSON.parse config.public_manifest_path.read
      else
        {}
      end
    end
end
