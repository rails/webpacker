require "active_support/core_ext/module/attribute_accessors"
require "active_support/logger"
require "active_support/tagged_logging"

module Webpacker
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Webpacker::Instance.new
  end

  delegate :logger, :logger=, :env, to: :instance
  delegate :config, :compiler, :manifest, :commands, to: :instance
  delegate :bootstrap, :clobber, :compile, to: :commands
end

require "webpacker/instance"
require "webpacker/configuration"
require "webpacker/manifest"
require "webpacker/compiler"
require "webpacker/commands"

require "webpacker/railtie" if defined?(Rails)
