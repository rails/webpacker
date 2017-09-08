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

  delegate :config, :compiler, :dev_server, to: :@webpacker

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
      raise Webpacker::Manifest::MissingEntryError, missing_file_from_manifest_error(name)
    end

    def missing_file_from_manifest_error(bundle_name)
      msg = <<-MSG
Webpacker can't find #{bundle_name} in #{config.public_manifest_file}. Possible causes:
1. You want to set webpacker.yml value of compile to true for your environment
   unless you are using the `webpack -w` or the webpack-dev-server.
2. Webpack has not yet re-run to reflect updates.
3. You have misconfigured Webpacker's config/webpacker.yml file.
4. Your Webpack configuration is not creating a manifest.
Your manifest contains:
#{JSON.pretty_generate(@data)}
      MSG
    end

    def data
      if config.cache_manifest?
        @data ||= load
      else
        refresh
      end
    end

    def load
      if config.public_manifest_file.exist?
        JSON.parse config.public_manifest_file.read
      else
        {}
      end
    end
end
