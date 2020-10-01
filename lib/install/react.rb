require "webpacker/configuration"
require "json"

say "Adding react-preset to babel configuration in package.json"
old_package = JSON.parse(File.read("package.json"))
old_package["babel"] = {
  "presets": ["./node_modules/@rails/webpacker/package/babel/preset-react.js"]
}
File.write("package.json", JSON.dump(old_package))

say "Copying react example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/react/hello_react.jsx", "#{Webpacker.config.source_entry_path}/hello_react.jsx"

say "Updating webpack paths to include .jsx file extension"
insert_into_file Webpacker.config.config_path, "- .jsx\n".indent(4), after: /\s+extensions:\n/

Dir.chdir(Rails.root) do
  say "Installing all react dependencies"
  run "yarn add react react-dom @babel/preset-react prop-types babel-plugin-transform-react-remove-prop-types"
end

say "Webpacker now supports react.js 🎉", :green
