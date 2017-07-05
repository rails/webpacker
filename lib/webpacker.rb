module Webpacker
  extend self

  def bootstrap
    Webpacker::Env.load
    Webpacker::Configuration.load
    Webpacker::Manifest.load
  end

  def compile
    Webpacker::Compiler.compile
    Webpacker::Manifest.load
  end

  def env
    Webpacker::Env.current.inquiry
  end
end

require_relative "webpacker/env"
require_relative "webpacker/configuration"
require_relative "webpacker/manifest"
require_relative "webpacker/compiler"
require_relative "webpacker/railtie" if defined?(Rails)
