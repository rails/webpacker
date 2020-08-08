require "webpacker/configuration"

say "Copying Elm example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/elm/hello_elm.js",
  "#{Webpacker.config.source_entry_path}/hello_elm.js"

say "Copying Elm app file to #{Webpacker.config.source_path}"
copy_file "#{__dir__}/examples/elm/Main.elm",
  "#{Webpacker.config.source_path}/Main.elm"

Dir.chdir(Rails.root) do
  say "Installing all Elm dependencies"
  run "yarn add elm elm-webpack-loader"
  run "yarn add --dev elm-hot-webpack-loader"
  run "yarn run elm init"
  run "yarn run elm make #{Webpacker.config.source_path}/Main.elm"
end

say "Updating Elm source location"
gsub_file "elm.json", /\"src\"\n/,
  %("#{Webpacker.config.source_path.relative_path_from(Rails.root)}"\n)

say "Updating .gitignore to include elm-stuff folder"
insert_into_file ".gitignore", "/elm-stuff\n", before: "/node_modules\n"

say "Webpacker now supports Elm 🎉", :green
