module Webpacker
  def self.bootstrap
    Webpacker::Env.load
    Webpacker::Configuration.load
    Webpacker::Manifest.load
  end
end

require "webpacker/railtie" if defined?(Rails)
