require "rake"

module Webpacker::Compiler
  extend self

  delegate :cache_path, :output_path, :source, to: Webpacker::Configuration

  # Additional paths that test compiler needs to watch
  # Webpacker::Compiler.watched_paths << 'bower_components'
  mattr_accessor(:watched_paths) { [] }

  def compile
    if stale?
      cache_source_timestamp

      compile_task.invoke
      compile_task.reenable
    end
  end

  def fresh?
    if cached_timestamp_path.exist? && output_path.exist?
      cached_timestamp_path.read == current_source_timestamp
    else
      false
    end
  end

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

    def compile_task
      @compile_task ||= load_rake_task("webpacker:compile")
    end

    def load_rake_task(name)
      load_rakefile unless Rake::Task.task_defined?(name)
      Rake::Task[name]
    end

    def load_rakefile
      @load_rakefile ||= Rake.load_rakefile(Rails.root.join("Rakefile"))
    end
end
