require "open3"
require "webpacker/env"
require "webpacker/configuration"

module Webpacker::Compiler
  extend self

  # Additional paths that test compiler needs to watch
  # Webpacker::Compiler.watched_paths << 'bower_components'
  mattr_accessor(:watched_paths) { [] }

  # Compiler cache directory
  # Webpacker::Compiler.cache_dir = 'tmp/cache'
  mattr_accessor(:cache_dir) { "tmp/webpacker" }

  # Compiles all packs if any are stale. Returns false if the compilation failed, otherwise truthy.
  def compile
    if stale?
      cache_source_timestamp
      run_webpack
    else
      Rails.logger.debug "[Webpacker] All assets are fresh, no compiling needed"
    end
  end

  # Returns true if all the compiled packs are up to date with the underlying asset files.
  def fresh?
    if File.exist?(cached_timestamp_path) && File.exist?(Webpacker::Configuration.output_path)
      File.read(cached_timestamp_path) != current_source_timestamp
    else
      false
    end
  end

  # Returns true if the compiled packs are out of date with the underlying asset files.
  def stale?
    !fresh?
  end

  # FIXME: Deprecate properly
  alias_method :compile?, :fresh?

  def default_watched_paths
    ["#{Webpacker::Configuration.source}/**/*", "yarn.lock", "package.json", "config/webpack/**/*"].freeze
  end


  private
    def current_source_timestamp
      files = Dir[*default_watched_paths, *watched_paths].reject { |f| File.directory?(f) }
      files.map { |f| File.mtime(f).utc.to_i }.max.to_s
    end

    def cache_source_timestamp
      File.write(cached_timestamp_path, current_source_timestamp)
    end

    def cached_timestamp_path
      FileUtils.mkdir_p(cache_dir) unless File.directory?(cache_dir)
      Rails.root.join(cache_dir, ".compiler-timestamp")
    end

    def run_webpack
      sterr, stdout, status = Open3.capture3(webpack_env, "#{RbConfig.ruby} ./bin/webpack")

      if status.success?
        Rails.logger.info \
          "[Webpacker] Compiled digests for all packs in #{Webpacker::Configuration.entry_path}: " +
          JSON.parse(File.read(Webpacker::Configuration.manifest_path)).to_s
        true
      else
        Rails.logger.error "[Webpacker] Compilation Failed:\n#{sterr}\n#{stdout}"
        false
      end
    end

    def webpack_env
      { "NODE_ENV" => Webpacker.env, "ASSET_HOST" => ActionController::Base.helpers.compute_asset_host }
    end
end
