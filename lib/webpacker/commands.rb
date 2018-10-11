class Webpacker::Commands
  delegate :config, :compiler, :manifest, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def clean
    return if !config.public_output_path.exist? || !config.public_manifest_path.exist?

    files_on_filesystem = Dir.glob("#{config.public_output_path}/**/*").select { |f| File.file? f }
    files_in_manifest = manifest.refresh.values.map { |f| File.join config.root_path, "public", f }

    count_to_keep = 2
    versions_to_keep = files_in_manifest.flat_map do |file_in_manifest|
      file_prefix, file_ext = file_in_manifest.scan(/(.*)[0-9a-f]{20}(.*)/).first
      versions_of_file = Dir.glob("#{file_prefix}*#{file_ext}").grep(/#{file_prefix}[0-9a-f]{20}#{file_ext}/)
      versions_of_file.map do |version_of_file|
        [version_of_file, File.mtime(version_of_file).utc.to_i]
      end.sort_by(&:last).reverse.first(count_to_keep).map(&:first)
    end

    manifest_file = File.join config.public_output_path, "manifest.json"
    files_to_be_removed = files_on_filesystem - files_in_manifest - versions_to_keep - [manifest_file]

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
