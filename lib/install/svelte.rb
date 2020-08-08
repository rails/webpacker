require "webpacker/configuration"

say "Copying Svelte example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/svelte/hello_svelte.js",
  "#{Webpacker.config.source_entry_path}/hello_svelte.js"

say "Copying Svelte app file to #{Webpacker.config.source_path}"
copy_file "#{__dir__}/examples/svelte/app.svelte",
  "#{Webpacker.config.source_path}/app.svelte"

say "Installing all Svelte dependencies"
run "yarn add svelte svelte-loader"

say "Webpacker now supports Svelte 🎉", :green
