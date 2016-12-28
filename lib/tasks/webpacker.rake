PACKS_PATH        = Rails.root.join('public/packs')
PACK_DIGESTS_PATH = PACKS_PATH.join('digests.json')

WEBPACKER_APP_TEMPLATE_PATH = File.expand_path('../install/template.rb', File.dirname(__FILE__))

namespace :webpacker do
  desc "compile javascript packs using webpack for production with digests"
  task :compile do
    webpack_digests_json = JSON.parse(`WEBPACK_ENV=production ./bin/webpack --json`)['assetsByChunkName'].to_json

    FileUtils.mkdir_p(PACKS_PATH)
    File.open(PACK_DIGESTS_PATH, 'w+') { |file| file.write webpack_digests_json }

    puts "Compiled digests for all packs in #{PACK_DIGESTS_PATH}: "
    puts webpack_digests_json
  end

  desc "install webpacker in this application"
  task :install do
    exec "./bin/rails app:template LOCATION=#{WEBPACKER_APP_TEMPLATE_PATH}"
  end

  namespace :install do
    desc "install everything needed for react"
    task :react do
      config_path = Rails.root.join('config/webpack/shared.js')
      config = File.read(config_path)

      if config =~ /presets:\s*\[\s*\[\s*'latest'/
        puts "Replacing loader presets to include react in #{config_path}"
        config.gsub!(/presets:(\s*\[)(\s*)\[(\s)*'latest'/, "presets:\\1\\2'react',\\2[\\3'latest'")
      else
        puts "Couldn't automatically update loader presets in #{config_path}. Please set presets: [ 'react', [ 'latest', { 'es2015': { 'modules': false } } ] ]."
      end

      if config.include?("test: /\\.js(.erb)?$/")
        puts "Replacing loader test to include react in #{config_path}"
        config.gsub!("test: /\\.js(.erb)?$/", "test: /\\.jsx?(.erb)?$/")
      else
        puts "Couldn't automatically update loader test in #{config_path}. Please set test: /\.jsx?(.erb)?$/."
      end

      File.write config_path, config

      puts "Copying react example to app/javascript/packs/hello_react.js"
      FileUtils.copy File.expand_path('../install/react/hello_react.js', File.dirname(__FILE__)),
        Rails.root.join('app/javascript/packs/hello_react.js')

      exec './bin/yarn add --dev babel-preset-react && ./bin/yarn add react react-dom'
    end

    desc "install everything needed for vue"
    task :vue do
      config_path = Rails.root.join('config/webpack/shared.js')
      config = File.read(config_path)

      if config.include?("presets: ['es2015']")
        puts "Replacing loader presets to include react in #{config_path}"
        config.gsub!(/presets: \['es2015'\]/, "presets: ['react', 'es2015']")
      else
        puts "Couldn't automatically update loader presets in #{config_path}. Please set presets: ['react', 'es2015']."
      end

      if config.include?("test: /\\.js$/")
        puts "Replacing loader test to include jsx in #{config_path}"
        config.gsub!("test: /\\.js$/", "test: /\\.jsx?$/")
      else
        puts "Couldn't automatically update loader test in #{config_path}. Please set test: /\.jsx?$/."
      end

      File.write config_path, config

      puts "Copying react example to app/javascript/packs/hello_vue.js"
      FileUtils.copy File.expand_path('../install/vue/hello_vue.js', File.dirname(__FILE__)),
        Rails.root.join('app/javascript/packs/hello_vue.js')

      exec './bin/yarn add --dev babel-preset-react  && ./bin/yarn add vue vue-loader vuex vue-resource vue-router vue-validator'

    end
  end
end
