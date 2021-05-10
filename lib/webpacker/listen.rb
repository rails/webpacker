require "pathname"
require "mutex_m"
require "listen"

class Webpacker::Listen
  include Mutex_m

  def initialize(webpacker:, watched_paths:, latency: nil)
    super()
    @webpacker   = webpacker
    @files       = Set.new
    @directories = Set.new
    add(*watched_paths)
    @listener = ::Listen.to(*base_directories, latency: latency, &method(:changed))
    @listener.start
  end

  private

    attr_reader :webpacker, :files, :directories

    delegate :compiler, :manifest, :logger, to: :webpacker

    def add(*items)
      items = items.flatten.map do |item|
        Pathname.new(item)
      end

      items = items.select do |item|
        if item.symlink?
          item.readlink.exist?.tap do |exists|
            if !exists
              logger.debug { "add: ignoring dangling symlink: #{item.inspect} -> #{item.readlink.inspect}" }
            end
          end
        else
          item.exist?
        end
      end

      synchronize {
        items.each do |item|
          if item.directory?
            directories << item.realpath.to_s
          else
            begin
              files << item.realpath.to_s
            rescue Errno::ENOENT
              # Race condition. Ignore symlinks whose target was removed
              # since the check above, or are deeply chained.
              logger.debug { "add: ignoring now-dangling symlink: #{item.inspect} -> #{item.readlink.inspect}" }
            end
          end
        end
      }
    end

    def watching?(file)
      files.include?(file) || file.start_with?(*directories)
    end

    def changed(modified, added, removed)
      synchronize do
        if (modified + added + removed).any? { |f| watching?(f) }
          compiler.stale!
          manifest.reset
        end
      end
    end

    def base_directories
      @base_directories ||= (
        files.reject { |f| f.start_with?(*directories) }.map { |f| File.expand_path("#{f}/..") } +
        directories.to_a
      ).uniq.map { |path| Pathname.new(path) }
    end
end
