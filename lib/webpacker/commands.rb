class Webpacker::Commands
  delegate :config, :compiler, :manifest, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def clean(count_to_keep = 2)
    if config.public_output_path.exist? && config.public_manifest_path.exist?
      files_in_manifest = process_manifest_hash(manifest.refresh)
      files_to_be_removed = files_in_manifest.flat_map do |file_in_manifest|
        file_prefix, file_ext = file_in_manifest.scan(/(.*)[0-9a-f]{20}(.*)/).first
        versions_of_file = Dir.glob("#{file_prefix}*#{file_ext}").grep(/#{file_prefix}[0-9a-f]{20}#{file_ext}/)
        versions_of_file.map do |version_of_file|
          next if version_of_file == file_in_manifest

          [version_of_file, File.mtime(version_of_file).utc.to_i]
        end.compact.sort_by(&:last).reverse.drop(count_to_keep).map(&:first)
      end

      files_to_be_removed.each { |f| File.delete f }
    end
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
    def process_manifest_hash(manifest_hash)
      manifest_hash.values.map do |value|
        next process_manifest_hash(value) if value.is_a?(Hash)

        File.join(config.root_path, "public", value)
      end.flatten
    end
end
