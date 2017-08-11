class Webpacker::Configuration
  delegate :root_path, :config_path, :env, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def refresh
    @data = load
  end

  def source_path
    root_path.join(fetch(:source_path))
  end

  def source_entry_path
    source_path.join(fetch(:source_entry_path))
  end

  def public_path
    root_path.join("public")
  end

  def public_output_path
    public_path.join(fetch(:public_output_path))
  end

  def public_manifest_path
    public_output_path.join("manifest.json")
  end

  def cache_path
    root_path.join(fetch(:cache_path))
  end

  def compile?
    fetch(:compile)
  end

  private
    def fetch(key)
      data.fetch(key, defaults[key])
    end

    def data
      if env.development?
        refresh
      else
        @data ||= load
      end
    end

    def load
      YAML.load(config_path.read)[env].deep_symbolize_keys
    end

    def defaults
      @defaults ||= \
        YAML.load(File.read(File.expand_path("../../install/config/webpacker.yml", __FILE__)))[env].deep_symbolize_keys
    end
end
