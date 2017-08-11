require "open3"

class Webpacker::Compiler
  # Additional paths that test compiler needs to watch
  # Webpacker::Compiler.watched_paths << 'bower_components'
  mattr_accessor(:watched_paths) { [] }

  delegate :config, :logger, :env, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def compile
    if stale?
      record_compilation_timestamp
      run_webpack
    else
      logger.debug "No compiling needed as everything is fresh"
    end
  end

  # Returns true if all the compiled packs are up to date with the underlying asset files.
  def fresh?
    source_last_changed_at == source_compiled_from_last_change_at
  end

  # Returns true if the compiled packs are out of date with the underlying asset files.
  def stale?
    !fresh?
  end

  private
    def source_compiled_from_last_change_at
      compilation_timestamp_path.read if compilation_timestamp_path.exist? && config.public_manifest_path.exist?
    end

    def source_last_changed_at
      files = Dir[*default_watched_paths, *watched_paths].reject { |f| File.directory?(f) }
      files.map { |f| File.mtime(f).utc.to_i }.max.to_s
    end

    def record_compilation_timestamp
      config.cache_path.mkpath
      compilation_timestamp_path.write(source_last_changed_at)
    end

    def run_webpack
      logger.info "Compiling…"

      sterr, stdout, status = Open3.capture3(webpack_env, "#{RbConfig.ruby} ./bin/webpack")

      if status.success?
        logger.info "Compiled all packs in #{config.source_entry_path}"
      else
        logger.error "Compilation failed:\n#{sterr}\n#{stdout}"
      end

      status.success?
    end


    def default_watched_paths
      ["#{config.source_path}/**/*", "yarn.lock", "package.json", "config/webpack/**/*"].freeze
    end

    def compilation_timestamp_path
      config.cache_path.join(".compiled-from-last-change-at")
    end

    def webpack_env
      { "NODE_ENV" => env, "ASSET_HOST" => ActionController::Base.helpers.compute_asset_host }
    end
end
