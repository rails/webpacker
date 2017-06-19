require "webpacker/configuration"
require "webpacker/node_bundler"

node_bundler = Webpacker::NodeBundler.command

puts "Copying vue loader to config/webpack/loaders"
copy_file "#{__dir__}/config/loaders/installers/vue.js", "config/webpack/loaders/vue.js"

puts "Copying the example entry file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/vue/hello_vue.js", "#{Webpacker::Configuration.entry_path}/hello_vue.js"

puts "Copying vue app file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/vue/app.vue", "#{Webpacker::Configuration.entry_path}/app.vue"

puts "Installing all vue dependencies"
run "#{node_bundler} vue vue-loader vue-template-compiler"

puts "Webpacker now supports vue.js 🎉"
