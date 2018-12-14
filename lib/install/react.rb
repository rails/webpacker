require "webpacker/configuration"
require "fileutils"

replace_babel_config = FileUtils.compare_file(Rails.root.join("babel.config.js"), "#{__dir__}/config/babel.config.js")

say "Copying babel.config.js to app root directory"
copy_file "#{__dir__}/examples/react/babel.config.js", "babel.config.js", force: replace_babel_config

say "Copying react example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/react/hello_react.jsx", "#{Webpacker.config.source_entry_path}/hello_react.jsx"

say "Updating webpack paths to include .jsx file extension"
insert_into_file Webpacker.config.config_path, "- .jsx\n".indent(4), after: /\s+extensions:\n/

say "Installing all react dependencies"
run "yarn add react react-dom @babel/preset-react prop-types babel-plugin-transform-react-remove-prop-types"

say "Webpacker now supports react.js 🎉", :green
