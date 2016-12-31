class Webpacker::Middleware
  class TimedOutError < StandardError
    def initialize(message = nil)
      message = "\n\n#{message}\n\n" if message
      super
    end
  end

  class WebpackError < StandardError
    def initialize(message = nil)
      message = "\n\n#{message}\n\n" if message
      super
    end
  end

  def initialize(app)
    @app = app
    @file = Rails.root.join("tmp", "webpack-stats.json")
  end

  def call(env)
    @status, @headers, @response = @app.call(env)
    timeout = 5.seconds
    start = now

    timed_out = false

    while compiling? && !timed_out
      sleep 0.1
      raise TimedOutError, "Timed out waiting for webpack status" if (now - timeout) > start
    end

    errors!

    [@status, @headers, @response]
  end

  private

    def now
      Time.now.utc
    end

    def status
      JSON.parse(File.read(@file))["status"]
    end

    def compiling?
      status == "compiling"
    rescue Errno::ENOENT
      false
    end

    def errors!
      return if status != "error"
      json = JSON.parse(File.read(@file))

      raise WebpackError, json["message"]
    end
end
