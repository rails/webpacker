require "webpacker/configuration"

namespace :webpacker do
  namespace :install do
    desc "Install everything needed for Angular"
    task angular: ["webpacker:verify_install"] do
      shared_config_path = Webpacker::Configuration.shared_config_path
      config             = File.read(shared_config_path)

      if config.include?("ts-loader")
        puts "The configuration file already has a reference to ts-loader, skipping the test rule..."
      else
        puts "Adding a loader rule to include ts-loader for .ts files in #{shared_config_path}..."
        config.gsub!(/rules:(\s*\[)(\s*\{)/, "rules:\\1\\2 test: /\.ts$/, loader: 'ts-loader' },\\2")
      end

      if config =~ /["'].ts["']/
        puts "The configuration file already has a reference to .ts extension, skipping the addition of this extension to the list..."
      else
        puts "Adding '.ts' in loader extensions in #{shared_config_path}..."
        config.gsub!(/extensions = (.*')(\s*\])/, "extensions = \\1, '.ts'\\2")
      end

      File.write shared_config_path, config

      puts "Copying Angular example to #{Webpacker::Configuration.entry_path}"
      FileUtils.copy File.expand_path("../../install/examples/angular/hello_angular.js", __dir__),
        Rails.root.join(Webpacker::Configuration.entry_path, "hello_angular.js")

      puts "Copying Angular Hello app to #{Webpacker::Configuration.source_path}"
      FileUtils.copy_entry File.expand_path("../../install/examples/angular/hello_angular", __dir__),
        Rails.root.join(Webpacker::Configuration.source_path, "hello_angular")

      puts "Copying tsconfig.json to the Rails root directory"
      FileUtils.copy File.expand_path("../../install/examples/angular/tsconfig.json", __dir__),
        Rails.root.join("tsconfig.json")

      exec "./bin/yarn add typescript ts-loader core-js zone.js rxjs @angular/core @angular/common @angular/compiler @angular/platform-browser @angular/platform-browser-dynamic"
    end
  end
end
