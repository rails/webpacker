say "Copying the example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/stimulus/hello_stimulus.js",
  "#{Webpacker.config.source_entry_path}/hello_stimulus.js"

say "creating controllers directory"
directory "#{__dir__}/examples/stimulus/controllers", "#{Webpacker.config.source_entry_path}/controllers"

say "Installing all Stimulus dependencies"
run "yarn add stimulus"

say "Webpacker now supports Stimulus.js 🎉", :green
