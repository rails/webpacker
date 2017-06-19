require "webpacker/configuration"
require "webpacker/node_bundler"

node_bundler = Webpacker::NodeBundler.command
node_bundler_dev = Webpacker::NodeBundler.command_dev

puts "Copying elm loader to config/webpack/loaders"
copy_file "#{__dir__}/config/loaders/installers/elm.js",
          "config/webpack/loaders/elm.js"

puts "Copying elm example entry file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/elm/Main.elm", "#{Webpacker::Configuration.entry_path}/Main.elm"

puts "Copying elm app file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/elm/hello_elm.js",
          "#{Webpacker::Configuration.entry_path}/hello_elm.js"

puts "Installing all elm dependencies"
run "#{node_bundler} elm elm-webpack-loader"
run "#{node_bundler_dev} elm-hot-loader"
run "node #{Webpacker::Configuration.node_modules_bin_path}/elm-package install --yes"

puts "Updating Webpack paths to include Elm file extension"
insert_into_file Webpacker::Configuration.file_path, "    - .elm\n", after: /extensions:\n/

puts "Updating elm source location"
source_path = File.join(Webpacker::Configuration.source, Webpacker::Configuration.fetch(:source_entry_path))
gsub_file "elm-package.json", /\"\.\"\n/, %("#{source_path}"\n)

puts "Updating .gitignore to include elm-stuff folder"
insert_into_file ".gitignore", "/elm-stuff\n", before: "/node_modules\n"

puts "Webpacker now supports elm 🎉"
