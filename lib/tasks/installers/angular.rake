namespace :webpacker do
  namespace :install do
    desc "Install everything needed for Angular"
    task :angular do
      config_path = Rails.root.join('config/webpack/shared.js')

      config = begin
        File.read(config_path)
      rescue Errno::ENOENT
        puts 'Webpack config not found. Make sure webpacker:install' \
        ' is run successfully before installing angular'
        exit!
      end

      if config.include?('ts-loader')
        puts "The configuration file already has a reference to ts-loader, skipping the test rule..."
      else
        puts "Adding a loader rule to include ts-loader for .ts files in #{config_path}..."
        config.gsub!(/rules:(\s*\[)(\s*\{)/, "rules:\\1\\2 test: /\.ts$/, loader: 'ts-loader' },\\2")
      end

      if config =~ /["'].ts["']/
        puts "The configuration file already has a reference to .ts extension, skipping the addition of this extension to the list..."
      else
        puts "Adding '.ts' in loader extensions in #{config_path}..."
        config.gsub!(/extensions:(.*')(\s*\])/, "extensions:\\1, '.ts'\\2")
      end

      File.write config_path, config

      puts "Copying Angular example to app/javascript/packs/hello_angular.js"
      FileUtils.copy File.expand_path('../../install/examples/angular/hello_angular.js', __dir__),
        Rails.root.join('app/javascript/packs/hello_angular.js')

      puts "Copying Angular Hello app to app/javascript/hello_angular"
      FileUtils.copy_entry File.expand_path('../../install/examples/angular/hello_angular', __dir__),
        Rails.root.join('app/javascript/hello_angular')

      puts "Copying tsconfig.json to the Rails root directory"
      FileUtils.copy File.expand_path('../../install/examples/angular/tsconfig.json', __dir__),
        Rails.root.join('tsconfig.json')

      exec './bin/yarn add typescript ts-loader core-js zone.js rxjs @angular/core @angular/common @angular/compiler @angular/platform-browser @angular/platform-browser-dynamic'
    end
  end
end
