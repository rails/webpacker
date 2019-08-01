require "webpacker/configuration"

say "Copying elm loader to config/webpack/loaders"
copy_file "#{__dir__}/loaders/elm.js", Rails.root.join("config/webpack/loaders/elm.js").to_s

say "Adding elm loader to config/webpack/environment.js"
insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const elm =  require('./loaders/elm')\n",
  after: /require\(('|")@rails\/webpacker\1\);?\n/

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.loaders.prepend('elm', elm)\n",
  before: "module.exports"

say "Copying Elm example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/elm/hello_elm.js",
  "#{Webpacker.config.source_entry_path}/hello_elm.js"

say "Copying Elm app file to #{Webpacker.config.source_path}"
copy_file "#{__dir__}/examples/elm/Main.elm",
  "#{Webpacker.config.source_path}/Main.elm"

say "Installing all Elm dependencies"
run "yarn add elm elm-webpack-loader"
run "yarn add --dev elm-hot-webpack-loader"
run "yarn run elm init"
run "yarn run elm make #{Webpacker.config.source_path}/Main.elm"

say "Updating webpack paths to include .elm file extension"
insert_into_file Webpacker.config.config_path, "- .elm\n".indent(4), after: /\s+extensions:\n/

say "Updating Elm source location"
gsub_file "elm.json", /\"src\"\n/,
  %("#{Webpacker.config.source_path.relative_path_from(Rails.root)}"\n)

say "Updating .gitignore to include elm-stuff folder"
insert_into_file ".gitignore", "/elm-stuff\n", before: "/node_modules\n"

say "Webpacker now supports Elm 🎉", :green
