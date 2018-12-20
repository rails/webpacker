require "webpacker/configuration"

say "Copying bucklescript (reason to javascript) loader to config/webpack/loaders"
copy_file "#{__dir__}/loaders/bucklescript.js", Rails.root.join("config/webpack/loaders/bucklescript.js").to_s

say "Adding BuckleScript loader to config/webpack/environment.js"
insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const bsLoader =  require('./loaders/bucklescript')\n",
  after: "require('@rails/webpacker')\n"

say "Prependig BuckleScript loader in the loaders list in config/webpack/environment.js"
insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.loaders.prepend('bucklescript', bsLoader)\n",
  before: "module.exports"

say "Copying BuckleScript configuration to project"
copy_file "#{__dir__}/examples/reason/bsconfig.json", Rails.root.join("bsconfig.json").to_s

say "Copying Reason example file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/reason/hello_reason.js",
  "#{Webpacker.config.source_entry_path}/hello_reason.js"

say "Copying Reason app files to #{Webpacker.config.source_path}"
copy_file "#{__dir__}/examples/reason/Greeting.re", "#{Webpacker.config.source_path}/Greeting.re"
copy_file "#{__dir__}/examples/reason/App.re", "#{Webpacker.config.source_path}/App.re"

say "Installing all Reason and ReasonReact dependencies"
run "yarn add bs-platform bs-loader react react-dom reason-react"

say "Updating webpack paths to include .re file extension"
insert_into_file Webpacker.config.config_path, "- .re\n".indent(4), after: /\s+extensions:\n/

say "Updating .gitignore to exclude unnecessary bucklescript generated files"
insert_into_file ".gitignore", "\n# Ignore bucklescript generated files.\n.merlin\n.bsb.lock\n/lib/bs\n\n", after: "/node_modules\n"

say "Webpacker now supports Reason and ReasonReact ⚛ 🎉", :green
