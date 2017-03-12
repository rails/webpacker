# Installs modules to enable assets linking, compiling and digesting
# with webpack

require "json"
require "webpacker/configuration"

# Use existing package.json
# Add new options for assets
begin
  config = Webpacker::Configuration.config
  config[:scripts][:postinstall] = "npm rebuild node-sass"
  config[:webpacker][:assets] = true
rescue NoMethodError
  puts "Error: Webpacker core config and scripts key not found in package.json. Make sure webpacker:install is run successfully"
  exit!
end

# Write to package.json
File.open(Rails.root.join("package.json"), "w+") do |file|
  file.write(JSON.pretty_generate(config))
end

copy_file "#{File.expand_path("..", __dir__)}/config/assets.js", "config/webpack/assets.js"

assets_webpack_config = <<-EOS
const { webpacker } = require('../../package.json')

if (webpacker.assets) {
  const assetsConfig = require('./assets.js')
  sharedConfig.config = merge(sharedConfig.config, assetsConfig)
}
EOS

insert_into_file "config/webpack/development.js",
  assets_webpack_config,
  after: "const sharedConfig = require('./shared.js')\n"

insert_into_file "config/webpack/production.js",
  assets_webpack_config,
  after: "const sharedConfig = require('./shared.js')\n"

run "./bin/yarn add extract-text-webpack-plugin node-sass file-loader sass-loader css-loader style-loader"
