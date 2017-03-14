require "webpacker/manifest"
require "webpacker/dev_server"

# Translates a logical reference for a pack source into the final
# path needed in the HTML using generated manifest.json file.
class Webpacker::Source
  def initialize(name, options = {})
    @name    = name
    @options = options
  end

  def path
    if Webpacker::DevServer.running?
      Webpacker::DevServer.resolve(compute_source_with_extname)
    else
      Webpacker::Manifest.lookup(compute_source_with_extname)
    end
  end

  private
    attr_accessor :name, :options

    def compute_source_with_extname
      "#{name}#{ActionController::Base.helpers.compute_asset_extname(name, options)}"
    end
end
