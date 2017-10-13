require "rails/railtie"

require "webpacker/helper"
require "webpacker/dev_server_proxy"

class Webpacker::Railtie < ::Rails::Railtie
  # Allows Webpacker config values to be set via Rails env config files
  config.webpacker = ActiveSupport::OrderedOptions.new

  # ================================
  # Check Yarn Integrity Initializer
  # ================================
  #
  # development (on by default):
  #
  #    to turn off:
  #     - edit config/environments/development.rb
  #     - add `config.webpacker.check_yarn_integrity = false`
  #
  # production (off by default):
  #
  #    to turn on:
  #     - edit config/environments/production.rb
  #     - add `config.webpacker.check_yarn_integrity = false`
  initializer "webpacker.yarn_check" do |app|
    if app.config.webpacker[:check_yarn_integrity] || (!app.config.webpacker.key?(:check_yarn_integrity) && Rails.env.development?)
      ok = system("yarn check --integrity")

      if !ok
        warn "\n\n"
        warn "========================================"
        warn "  Your Yarn packages are out of date!"
        warn "  Please run `yarn install` to update."
        warn "========================================"
        warn "\n\n"
        warn "To disable this check, please add `config.webpacker.check_yarn_integrity = false`"
        warn "to your Rails development config file (config/environments/development.rb)."
        warn "\n\n"

        exit(1)
      end
    end
  end

  initializer "webpacker.proxy" do |app|
    if Rails.env.development?
      app.middleware.insert_before 0,
        Rails::VERSION::MAJOR >= 5 ?
          Webpacker::DevServerProxy : "Webpacker::DevServerProxy", ssl_verify_none: true
    end
  end

  initializer "webpacker.helper" do
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    ActiveSupport.on_load :action_view do
      include Webpacker::Helper
    end
  end

  initializer "webpacker.logger" do
    config.after_initialize do
      if ::Rails.logger.respond_to?(:tagged)
        Webpacker.logger = ::Rails.logger
      else
        Webpacker.logger = ActiveSupport::TaggedLogging.new(::Rails.logger)
      end
    end
  end

  initializer "webpacker.bootstrap" do
    if defined?(Rails::Server) || defined?(Rails::Console)
      Webpacker.bootstrap
      Spring.after_fork { Webpacker.bootstrap } if defined?(Spring)
    end
  end

  rake_tasks do
    tasks_path = File.expand_path("../tasks", __dir__)
    Dir.glob("#{tasks_path}/**/*.rake").sort.each { |ext| load ext }
  end
end
