class Webpacker::Commands
  delegate :config, :compiler, :manifest, :logger, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def clean(count = 2)
    if config.public_output_path.exist? && config.public_manifest_path.exist? && versions.count > count
      versions.drop(count).flat_map(&:last).each do |file|
        File.delete(file) if File.file?(file)
        logger.info "Removed #{file}"
      end
    end

    true
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

  private
    def versions
      all_files       = Dir.glob("#{config.public_output_path}/**/*")
      manifest_config = Dir.glob("#{config.public_manifest_path}*")

      packs = all_files - manifest_config - current_version
      packs.group_by { |file| File.mtime(file).utc.to_i }.sort.reverse
    end

    def current_version
      manifest.refresh.values.map do |value|
        next if value.is_a?(Hash)

        File.join(config.root_path, "public", value)
      end.compact
    end
end
