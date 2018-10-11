class Webpacker::Commands
  delegate :config, :compiler, :manifest, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def clean
    return if !config.public_output_path.exist? || !config.public_manifest_path.exist?

    files_on_filesystem = Dir.glob("#{config.public_output_path}/**/*").select { |f| File.file? f }
    files_in_manifest = manifest.refresh.values.map { |f| File.join config.root_path, "public", f }
    manifest_file = File.join config.public_output_path, "manifest.json"
    files_to_be_removed = files_on_filesystem - files_in_manifest - [manifest_file]

    files_to_be_removed.each { |f| File.delete f }
  end

  def clobber
    config.public_output_path.rmtree if config.public_output_path.exist?
    config.cache_path.rmtree if config.cache_path.exist?
  end

  def bootstrap
    manifest.refresh
  end

  def compile
    compiler.compile.tap do |success|
      manifest.refresh if success
    end
  end
end
