class Webpacker::Configuration
  delegate :root_path, :config_path, :env, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def refresh
    @data = load
  end

  def source_path
    root_path.join(data[:source_path])
  end

  def source_entry_path
    source_path.join(data[:source_entry_path])
  end

  def public_path
    root_path.join("public")
  end

  def public_output_path
    public_path.join(data[:public_output_path])
  end

  def public_manifest_path
    public_output_path.join("manifest.json")
  end

  def cache_path
    root_path.join(data[:cache_path])
  end

  def compile?
    data[:compile]
  end

  private
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
end
