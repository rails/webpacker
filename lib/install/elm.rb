require "webpacker/configuration"

puts "Copying elm loader to #{Webpacker::Configuration.config_path}/loaders"
copy_file "#{__dir__}/config/loaders/installers/elm.js",
          "#{Webpacker::Configuration.config_path}/loaders/elm.js"

puts "Copying elm example entry file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/elm/Main.elm", "#{Webpacker::Configuration.entry_path}/Main.elm"

puts "Copying elm app file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/elm/hello_elm.js",
          "#{Webpacker::Configuration.entry_path}/hello_elm.js"

puts "Updating .gitignore to include elm-stuff folder"
insert_into_file ".gitignore", "/elm-stuff\n", before: "/node_modules\n"

puts "Installing all elm dependencies"
run "./bin/yarn add elm"
run "./bin/yarn add --dev elm-hot-loader elm-webpack-loader"
run "yarn run elm package install -- --yes"

puts "Webpacker now supports elm 🎉"
