class Webpacker::Commands
  delegate :config, :compiler, :manifest, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def bootstrap
    config.refresh
    manifest.refresh
  end

  def compile
    compiler.compile
    manifest.refresh
  end
end
