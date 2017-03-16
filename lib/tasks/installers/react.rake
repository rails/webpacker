require "webpacker/configuration"

namespace :webpacker do
  namespace :install do
    desc "Install everything needed for react"
    task react: ["webpacker:install:verify"] do
      shared_config_path = Webpacker::Configuration.shared_config_path
      config             = File.read(shared_config_path)

      if config =~ /presets:\s*\[\s*\[\s*'env'/
        puts "Replacing loader presets to include react in #{shared_config_path}"
        config.gsub!(/presets:(\s*\[)(\s*)\[(\s)*'env'/, "presets:\\1\\2'react',\\2[\\3'env'")
      else
        puts "Couldn't automatically update loader presets in #{shared_config_path}. Please set presets: [ 'react', [ 'env', { 'modules': false } ] ]."
      end

      if config.include?("test: /\\.js(\\.erb)?$/")
        puts "Replacing loader test to include react in #{shared_config_path}"
        config.gsub!("test: /\\.js(\\.erb)?$/", "test: /\\.(js|jsx)?(\\.erb)?$/")
      else
        puts "Couldn't automatically update loader test in #{shared_config_path}. Please set test: /\\.jsx?(\\.erb)?$/."
      end

      if config =~ /["'].jsx["']/
        puts "The configuration file already has a reference to .jsx extension, skipping the addition of this extension to the list..."
      else
        puts "Adding '.jsx' in loader extensions in #{shared_config_path}..."
        config.gsub!(/extensions = (.*')(\s*\])/, "extensions = \\1, '.jsx'\\2")
      end

      File.write shared_config_path, config

      puts "Copying .babelrc to project directory"
      FileUtils.copy File.expand_path("../../install/examples/react/.babelrc", __dir__),
        Rails.root

      puts "Copying react example to app/javascript/packs/hello_react.jsx"
      FileUtils.copy File.expand_path("../../install/examples/react/hello_react.jsx", __dir__),
        Rails.root.join("app/javascript/packs/hello_react.jsx")

      exec "./bin/yarn add react react-dom babel-preset-react"
    end
  end
end
