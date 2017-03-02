require "webpacker/manifest"
require "webpacker/package_json"

# Translates a logical reference for a pack source into the final
# path needed in the HTML using generated digests.json manifest.
class Webpacker::Source
  class SourceError < StandardError; end

  def initialize(filename)
    @filename = filename
  end

  def path
    if Rails.env.development? && dev_server_enabled?
      "http://#{dev_server[:host]}:#{dev_server[:port]}/#{filename}"
    else
      Webpacker::Manifest.lookup(filename)
    end
  end

  private

    attr_accessor :filename

    def dev_server
      Webpacker::PackageJson.dev_server
    end

    def dev_server_enabled?
      ENV["DEV_SERVER_ENABLED"] || dev_server[:enabled]
    end
end
