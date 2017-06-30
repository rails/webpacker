require "rake"

module Webpacker::Compiler
  extend self

  # Additional paths that test compiler needs to watch
  # Webpacker::Compiler.watched_paths << 'bower_components'
  mattr_accessor(:watched_paths) { [] }

  # Compiler cache directory
  # Webpacker::Compiler.cache_dir = 'tmp/cache'
  mattr_accessor(:cache_dir) { "tmp/webpacker" }

  def compile
    return unless compile?
    cache_source_timestamp
    compile_task.invoke
    compile_task.reenable
  end

  def compile?
    return true unless File.exist?(cached_timestamp_path)
    return true unless File.exist?(Webpacker::Configuration.output_path)

    File.read(cached_timestamp_path) != current_source_timestamp
  end

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
