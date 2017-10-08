require "webpacker/configuration"

say "Copying the example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/vue/hello_vue.js",
  "#{Webpacker.config.source_entry_path}/hello_vue.js"

say "Copying Vue app file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/vue/app.vue",
  "#{Webpacker.config.source_path}/app.vue"

say "Installing all Vue dependencies"
run "yarn add vue vue-loader vue-template-compiler"

say "Webpacker now supports Vue.js 🎉", :green
