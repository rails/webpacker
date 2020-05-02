class Webpacker::Commands
  delegate :config, :compiler, :manifest, :logger, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  # Cleanup old assets in the compile directory. By default it will
  # keep the latest version, 2 backups created within the past hour.
  #
  # Examples
  #
  #   To force only 1 backup to be kept, set count=1 and age=0.
  #
  #   To only keep files created within the last 10 minutes, set count=0 and
  #   age=600.
  #
  def clean(count = 2, age = 3600)
    if config.public_output_path.exist? && config.public_manifest_path.exist?
      versions
        .sort
        .reverse
        .each_with_index
        .drop_while do |(mtime, _), index|
          max_age = [0, Time.now - Time.at(mtime)].max
          max_age < age && index < count
        end
        .each do |(_, files), index|
          files.each do |file|
            if File.file?(file)
              File.delete(file)
              logger.info "Removed #{file}"
            end
          end
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
      packs.reject { |file| File.directory?(file) }.group_by { |file| File.mtime(file).utc.to_i }
    end

    def current_version
      packs = manifest.refresh.values.map do |value|
        next if value.is_a?(Hash)

        File.join(config.root_path, "public", "#{value}*")
      end.compact

      Dir.glob(packs).uniq
    end
end
