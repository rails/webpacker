require "webpacker/configuration"

say "Copying vue loader to config/webpack/loaders"
copy_file "#{__dir__}/loaders/erb.js", Rails.root.join("config/webpack/loaders/erb.js").to_s

say "Adding erb loader to config/webpack/environment.js"
insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const erb =  require('./loaders/erb')\n",
  after: "const { environment } = require('@rails/webpacker')\n"

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.loaders.append('erb', erb)\n",
  before: "module.exports"

say "Copying the example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/erb/hello_erb.js.erb",
  "#{Webpacker.config.source_entry_path}/hello_erb.js.erb"

say "Installing all Erb dependencies"
run "yarn add rails-erb-loader"

say "Webpacker now supports Erb in JS 🎉", :green
