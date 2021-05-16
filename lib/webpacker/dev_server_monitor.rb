class Webpacker::DevServerMonitor
  delegate :dev_server, :compiler, :config, :logger, to: :'Webpacker'
  delegate :host, :port, :connect_timeout, :connection_check_frequency, to: :dev_server

  def initialize
    @mutex = Mutex.new
  end

  def running?
    return @running if instance_variable_defined?(:@running)

    @running =
      if config.dev_server.present?
        check_connection
      else
        false
      end.tap do
        init_connection_checker
      end
  end

  private

    attr_reader :mutex

    def check_connection
      Socket.tcp(host, port, connect_timeout: connect_timeout).close
      true
    rescue StandardError
      false
    end

    def init_connection_checker
      mutex.synchronize { connection_checker }
    end

    def connection_checker
      return @connection_checker if @connection_checker

      @connection_checker = Thread.new { connection_checking_loop }
      @connection_checker.name = "DevServerMonitor#connection_checking_loop"
    end

    def connection_checking_loop
      loop do
        self.running = check_connection
        sleep(connection_check_frequency)
      end
    rescue => e # Need to display any exception in the thread loop
      logger.tagged("Webpacker") do
        logger.error("connection checking unexpected error #{e.inspect}")
      end
    end

    def running=(running)
      mutex.synchronize do
        handle_connection_state_change(was_running: @running, became_running: running)
        @running = running
      end
    end

    def handle_connection_state_change(was_running:, became_running:)
      return if was_running == became_running

      logger.tagged("Webpacker") { logger.debug("dev server became #{became_running ? 'up' : 'down'}") }
      # webpacker-dev-server maifest and the paths are not valid anymore
      compiler.stale! unless became_running
    end
end
