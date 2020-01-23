require "rails/railtie"

require "webpacker/helper"
require "webpacker/dev_server_proxy"

class Webpacker::Engine < ::Rails::Engine
  # Allows Webpacker config values to be set via Rails env config files
  config.webpacker = ActiveSupport::OrderedOptions.new

  initializer "webpacker.set_configs" do |app|
    if app.config.webpacker.key?(:check_yarn_integrity)
      Webpacker.config.check_yarn_integrity = app.config.webpacker.check_yarn_integrity
    end
  end

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
  #     - add `config.webpacker.check_yarn_integrity = true`
  initializer "webpacker.yarn_check" do |app|
    if File.exist?("yarn.lock") && Webpacker.config.config_path.exist? && Webpacker.config.check_yarn_integrity?
      output = `yarn check --integrity && yarn check --verify-tree 2>&1`

      unless $?.success?
        $stderr.puts "\n\n"
        $stderr.puts "========================================"
        $stderr.puts "  Your Yarn packages are out of date!"
        $stderr.puts "  Please run `yarn install --check-files` to update."
        $stderr.puts "========================================"
        $stderr.puts "\n\n"
        $stderr.puts "To disable this check, please change `check_yarn_integrity`"
        $stderr.puts "to `false` in your webpacker config file (config/webpacker.yml)."
        $stderr.puts "\n\n"
        $stderr.puts output
        $stderr.puts "\n\n"

        exit(1)
      end
    end
  end

  initializer "webpacker.proxy" do |app|
    insert_middleware = Webpacker.config.dev_server.present? rescue nil
    if insert_middleware
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
      if defined?(Spring)
        require "spring/watcher"
        Spring.after_fork { Webpacker.bootstrap }
        Spring.watch(Webpacker.config.config_path)
      end
    end
  end

  initializer "webpacker.set_source" do |app|
    if Webpacker.config.config_path.exist?
      app.config.javascript_path = Webpacker.config.source_path.relative_path_from(Rails.root.join("app")).to_s
    end
  end
end
