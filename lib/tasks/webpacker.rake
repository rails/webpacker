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

      if config.include?("presets: ['latest']")
        puts "Replacing loader presets to include react in #{config_path}"
        config.gsub!(/presets: \['latest'\]/, "presets: ['react', 'latest']")
      else
        puts "Couldn't automatically update loader presets in #{config_path}. Please set presets: ['react', 'latest']."
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
  end
end
