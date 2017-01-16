# Translates a logical reference for a pack source into the final path needed in the HTML.
# This translation takes into account whether digesting is configured to happen, which it
# is by default in the production environment (as set via
# `Rails.configuration.x.webpacker[:digesting] = true`).
class Webpacker::Source
  def initialize(name)
    @name = name
  end

  def path
    if config[:dev_server_host].present?
      "#{config[:dev_server_host]}/#{filename}"
    elsif config[:digesting]
      "/#{dist}/#{digested_filename}"
    else
      "/packs/#{filename}"
    end
  end

  private
    attr_accessor :name

    def config
      Rails.configuration.x.webpacker
    end

    def digested_filename
      Webpacker::Digests.lookup(name)
    end

    def dist
      config[:dist] || 'packs'
    end

    def filename
      "#{name}.js"
    end
end
