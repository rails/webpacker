namespace :webpacker do
  namespace :install do
    desc "Install everything needed for Vue"
    task :vue do
      config_path = Rails.root.join('config/webpack/shared.js')

      config = begin
        File.read(config_path)
      rescue Errno::ENOENT
        puts 'Webpack config not found. Make sure webpacker:install' \
        ' is run successfully before installing vue'
        exit!
      end

      # Module resolution https://webpack.js.org/concepts/module-resolution/
      if config.include?("'vue$':'vue/dist/vue.common.js'")
        puts "Couldn't automatically update module resolution in #{config_path}. Please set resolve { alias:{ 'vue$':'vue/dist/vue.common.js' } }."
      else
        config.gsub!(/resolve:(\s*\{)(\s*)extensions/,"resolve:\\1\\2alias: { 'vue$':'vue/dist/vue.common.js' },\\2extensions")
      end

      if config.include?("loader: 'url-loader?mimetype=image/png'")
        puts "Couldn't automatically update url-loader in #{config_path}. Please set { test: /\.png$/, loader: 'url-loader?mimetype=image/png' }."
      else
        config.gsub!(/module:(\s*\{)(\s*)rules:(\s*)\[/,"module:\\1\\2rules:\\3[\\2  { test: /\.png$/, loader: 'url-loader?mimetype=image/png'},")
      end

      if config.include?("loader: 'vue-loader',")
        puts "Couldn't automatically update vue-loader in #{config_path}. Please set { test: /.vue$/, loader: 'vue-loader', options: { loaders: { 'scss': 'vue-style-loader!css-loader!sass-loader', 'sass': 'vue-style-loader!css-loader!sass-loader?indentedSyntax'}}}."
      else
        config.gsub!(/module:(\s*\{)(\s*)rules:(\s*)\[/,"module:\\1\\2rules:\\3[\\2  {\\2    test: /\.vue$/, loader: 'vue-loader',\\2    options: {\\2      loaders: { 'scss': 'vue-style-loader!css-loader!sass-loader', 'sass': 'vue-style-loader!css-loader!sass-loader?indentedSyntax'}\\2    }\\2  },")
      end

      File.write config_path, config

      puts "Copying the Vue example to app/javascript/packs/vue"
      FileUtils.copy File.expand_path('../../install/examples/vue/hello_vue.js', File.dirname(__FILE__)),
        Rails.root.join('app/javascript/packs/hello_vue.js')

      FileUtils.copy File.expand_path('../../install/examples/vue/app.vue', File.dirname(__FILE__)),
        Rails.root.join('app/javascript/packs/app.vue')

      exec "./bin/yarn add vue vue-loader vue-template-compiler sass-loader node-sass css-loader url-loader axios"
    end
  end
end
