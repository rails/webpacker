require "open3"
require "webpacker/env"
require "webpacker/configuration"

module Webpacker::Compiler
  extend self

  delegate :cache_path, :output_path, :source, to: Webpacker::Configuration
  delegate :logger, to: Webpacker

  # Additional paths that test compiler needs to watch
  # Webpacker::Compiler.watched_paths << 'bower_components'
  mattr_accessor(:watched_paths) { [] }

  def compile
    if stale?
      cache_source_timestamp
      run_webpack
    else
      logger.debug "[Webpacker] All assets are fresh, no compiling needed"
    end
  end

  # Returns true if all the compiled packs are up to date with the underlying asset files.
  def fresh?
    if cached_timestamp_path.exist? && output_path.exist?
      cached_timestamp_path.read == current_source_timestamp
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
    ["#{source}/**/*", "yarn.lock", "package.json", "config/webpack/**/*"].freeze
  end

  private
    def current_source_timestamp
      files = Dir[*default_watched_paths, *watched_paths].reject { |f| File.directory?(f) }
      files.map { |f| File.mtime(f).utc.to_i }.max.to_s
    end

    def cache_source_timestamp
      cache_path.mkpath
      cached_timestamp_path.write(current_source_timestamp)
    end

    def cached_timestamp_path
      cache_path.join(".compiler-timestamp")
    end

    def run_webpack
      sterr, stdout, status = Open3.capture3(webpack_env, "#{RbConfig.ruby} ./bin/webpack")

      if status.success?
        logger.info "[Webpacker] Compiled all packs in #{Webpacker::Configuration.entry_path}"
        true
      else
        logger.error "[Webpacker] Compilation Failed:\n#{sterr}\n#{stdout}"
        false
      end
    end

    def webpack_env
      { "NODE_ENV" => Webpacker.env, "ASSET_HOST" => ActionController::Base.helpers.compute_asset_host }
    end
end
