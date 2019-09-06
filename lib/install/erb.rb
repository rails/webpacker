require "webpacker/configuration"

say "Copying erb rule to config/webpack/rules"
copy_file "#{__dir__}/rules/erb.js", Rails.root.join("config/webpack/rules/erb.js").to_s

say "Adding erb rule to config/webpack/environment.js"
insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const erb = require('./rules/erb')\n",
  after: /require\(('|")@rails\/webpacker\1\);?\n/

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.rules.prepend('erb', erb)\n",
  before: "module.exports"

say "Updating webpack paths to include .erb file extension"
insert_into_file Webpacker.config.config_path, "- .erb\n".indent(4), after: /\s+extensions:\n/

say "Copying the example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/erb/hello_erb.js.erb",
  "#{Webpacker.config.source_entry_path}/hello_erb.js.erb"

say "Installing all Erb dependencies"
run "yarn add rails-erb-loader"

say "Webpacker now supports Erb in JS 🎉", :green
