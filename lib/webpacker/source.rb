# Translates a logical reference for a pack source into the final path needed in the HTML.
# This translation takes into account whether digesting is configured to happen, which it
# is by default in the production environment (as set via
# `Rails.configuration.x.webpacker[:digesting] = true`).
class Webpacker::Source
  def initialize(name)
    @name = name
  end

  def path
    if digesting?
      "/packs/#{digested_filename}"
    else
      "/packs/#{filename}"
    end
  end

  private
    attr_accessor :name

    def digesting?
      Rails.configuration.x.webpacker[:digesting]
    end  

    def digested_filename
      Webpacker::Digests.lookup(name)
    end

    def filename
      "#{name}.js"
    end
end
