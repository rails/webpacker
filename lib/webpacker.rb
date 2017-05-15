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

  def caching
    Webpacker::Configuration.data.fetch(:caching, env.production?)
  end
end

require "webpacker/env"
require "webpacker/configuration"
require "webpacker/manifest"
require "webpacker/compiler"
require "webpacker/railtie" if defined?(Rails)
