require "webpacker/configuration"

puts "Copying react loader to #{Webpacker::Configuration.config_path}/loaders"
copy_file "#{__dir__}/config/loaders/installers/react.js", "config/webpack/loaders/react.js"

puts "Copying .babelrc to app root directory"
copy_file "#{__dir__}/examples/react/.babelrc", ".babelrc"

puts "Copying react example entry file to #{Webpacker::Configuration.entry_path}"
copy_file "#{__dir__}/examples/react/hello_react.jsx", "#{Webpacker::Configuration.entry_path}/hello_react.jsx"

puts "Installing all react dependencies"
run "./bin/yarn add react react-dom babel-preset-react"

puts "Webpacker now supports react.js 🎉"
