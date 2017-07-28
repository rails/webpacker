module Webpacker
  extend self

  def bootstrap
    Webpacker::Env.load_instance
    Webpacker::Configuration.load_instance
    Webpacker::DevServer.load_instance
    Webpacker::Manifest.load_instance
  end

  def compile
    Webpacker::Compiler.compile
    Webpacker::Manifest.load_instance
  end

  def env
    Webpacker::Env.current.inquiry
  end
end

require "webpacker/env"
require "webpacker/configuration"
require "webpacker/dev_server"
require "webpacker/manifest"
require "webpacker/compiler"
require "webpacker/railtie" if defined?(Rails)
