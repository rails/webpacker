require "webpacker/configuration"

say "Copying angular example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/angular/hello_angular.js", "#{Webpacker.config.source_entry_path}/hello_angular.js"

say "Copying hello_angular app to #{Webpacker.config.source_path}"
directory "#{__dir__}/examples/angular/hello_angular", "#{Webpacker.config.source_path}/hello_angular"

say "Installing all angular dependencies"
run "yarn add core-js zone.js rxjs @angular/core @angular/common @angular/compiler @angular/platform-browser @angular/platform-browser-dynamic"

say "Webpacker now supports angular 🎉", :green
