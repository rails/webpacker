namespace :webpacker do
  namespace :install do
    desc "Install everything needed for react"
    task :react do
      config_path = Rails.root.join('config/webpack/shared.js')

      config = begin
        File.read(config_path)
      rescue Errno::ENOENT
        puts 'Webpack config not found. Make sure webpacker:install is' \
        ' run successfully before installing react'
        exit!
      end

      if config =~ /presets:\s*\[\s*\[\s*'env'/
        puts "Replacing loader presets to include react in #{config_path}"
        config.gsub!(/presets:(\s*\[)(\s*)\[(\s)*'env'/, "presets:\\1\\2'react',\\2[\\3'env'")
      else
        puts "Couldn't automatically update loader presets in #{config_path}. Please set presets: [ 'react', [ 'env', { 'modules': false } ] ]."
      end

      if config.include?("test: /\\.js(\\.erb)?$/")
        puts "Replacing loader test to include react in #{config_path}"
        config.gsub!("test: /\\.js(\\.erb)?$/", "test: /\\.jsx?(\\.erb)?$/")
      else
        puts "Couldn't automatically update loader test in #{config_path}. Please set test: /\\.jsx?(\\.erb)?$/."
      end

      File.write config_path, config

      puts "Copying .babelrc to project directory"
      FileUtils.copy File.expand_path('../../install/examples/react/.babelrc', __dir__),
        Rails.root

      puts "Copying react example to app/javascript/packs/hello_react.jsx"
      FileUtils.copy File.expand_path('../../install/examples/react/hello_react.jsx', __dir__),
        Rails.root.join('app/javascript/packs/hello_react.jsx')

      exec './bin/yarn add react react-dom babel-preset-react'
    end
  end
end
