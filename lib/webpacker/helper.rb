require 'webpacker/source'

module Webpacker::Helper
  def javascript_pack_tag(name, **options)
    tag.script src: Webpacker::Source.new(name).path, **options
  end
end
