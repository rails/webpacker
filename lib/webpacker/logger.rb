require "active_support/core_ext/module/attribute_accessors"
require "active_support/logger"
require "active_support/tagged_logging"

module Webpacker::Logger
  mattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

  def ensure_log_goes_to_stdout
    old_logger = logger
    self.logger = ActiveSupport::Logger.new(STDOUT)
    yield
  ensure
    self.logger = old_logger
  end
end

Webpacker.extend Webpacker::Logger
