require "open3"
require "digest/sha1"

class Webpacker::Compiler
  # Additional paths that test compiler needs to watch
  # Webpacker::Compiler.watched_paths << 'bower_components'
  cattr_accessor(:watched_paths) { [] }

  # Additional environment variables that the compiler is being run with
  # Webpacker::Compiler.env['FRONTEND_API_KEY'] = 'your_secret_key'
  cattr_accessor(:env) { {} }

  delegate :config, :logger, to: :webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def compile
    if stale?
      run_webpack.tap do |success|
        # We used to only record the digest on success
        # However, the output file is still written on error, meaning that the digest should still be updated.
        # If it's not, you can end up in a situation where a recompile doesn't take place when it should.
        # See https://github.com/rails/webpacker/issues/2113
        record_compilation_digest
      end
    else
      logger.info "Everything's up-to-date. Nothing to do"
      true
    end
  end

  # Returns true if all the compiled packs are up to date with the underlying asset files.
  def fresh?
    watched_files_digest == last_compilation_digest
  end

  # Returns true if the compiled packs are out of date with the underlying asset files.
  def stale?
    !fresh?
  end

  private
    attr_reader :webpacker

    def last_compilation_digest
      compilation_digest_path.read if compilation_digest_path.exist? && config.public_manifest_path.exist?
    rescue Errno::ENOENT, Errno::ENOTDIR
    end

    def watched_files_digest
      files = Dir[*default_watched_paths, *watched_paths].reject { |f| File.directory?(f) }
      file_ids = files.sort.map { |f| "#{File.basename(f)}/#{Digest::SHA1.file(f).hexdigest}" }
      Digest::SHA1.hexdigest(file_ids.join("/"))
    end

    def record_compilation_digest
      config.cache_path.mkpath
      compilation_digest_path.write(watched_files_digest)
    end

    def run_webpack
      logger.info "Compiling..."

      stdout, stderr, status = Open3.capture3(
        webpack_env,
        "#{RbConfig.ruby} ./bin/webpack",
        chdir: File.expand_path(config.root_path)
      )

      if status.success?
        logger.info "Compiled all packs in #{config.public_output_path}"
        logger.error "#{stderr}" unless stderr.empty?

        if config.webpack_compile_output?
          logger.info stdout
        end
      else
        non_empty_streams = [stdout, stderr].delete_if(&:empty?)
        logger.error "Compilation failed:\n#{non_empty_streams.join("\n\n")}"
      end

      status.success?
    end

    def default_watched_paths
      [
        *config.resolved_paths_globbed,
        config.source_path_globbed,
        "yarn.lock", "package.json",
        "config/webpack/**/*"
      ].freeze
    end

    def compilation_digest_path
      config.cache_path.join("last-compilation-digest-#{webpacker.env}")
    end

    def webpack_env
      return env unless defined?(ActionController::Base)

      env.merge("WEBPACKER_ASSET_HOST"        => ENV.fetch("WEBPACKER_ASSET_HOST", ActionController::Base.helpers.compute_asset_host),
                "WEBPACKER_RELATIVE_URL_ROOT" => ENV.fetch("WEBPACKER_RELATIVE_URL_ROOT", ActionController::Base.relative_url_root))
    end
end
