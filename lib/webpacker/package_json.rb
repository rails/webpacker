# Loads the package.json file from app root to read the webpacker configuration

class Webpacker::PackageJson
  class PackageJsonError < StandardError; end
  class_attribute :instance
  attr_accessor :config

  class << self
    def load(path = Rails.root.join("package.json"))
      self.instance = new(path)
    end

    def config
      load if Rails.env.development?
      instance.config
    end

    def scripts
      config[:scripts]
    end

    def webpacker
      begin
        config[:webpacker]
      rescue NoMethodError
        raise PackageJsonError, "Error: Webpacker core config not found in package.json." \
                           " Make sure webpacker:install is run successfully"
      end
    end

    def dev_server
      begin
        config[:devServer]
      rescue NoMethodError
        raise PackageJsonError, "Error: webpack-dev-server config not found in package.json." \
                           " Make sure webpacker:install is run successfully"
      end
    end
  end

  private

    def initialize(path)
      @path = path
      @config = load
    end

    def load
      if File.exist?(@path)
        package_json = JSON.parse(File.read(@path))
        HashWithIndifferentAccess.new(package_json)
      else
        Rails.logger.info "Didn't find any package.json file at #{@path}. " \
        "You must first install webpacker via rails webpacker:install"
        {}
      end
    end
end
