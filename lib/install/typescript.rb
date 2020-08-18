require "webpacker/configuration"

additional_packages = ""
example_source = "typescript"

# Additional configuration is required for React projects
package_json = Rails.root.join("package.json")
if File.exist?(package_json)
  package = JSON.parse(File.read(package_json))
  package["dependencies"] ||= {}

  if package["dependencies"].keys.include?("react")
    additional_packages = "@types/react @types/react-dom"
    example_source = "react"
  end
end

say "Adding TypeScript preset to babel.config.js"
preset_options = { typescript: true }
preset_options["react"] = true if example_source == "react"
old_package = JSON.parse(File.read("package.json"))
old_package["babel"] = {
  "presets": [
    ["./node_modules/@rails/webpacker/package/babel/preset.js", preset_options]
  ]
}
File.write("package.json", JSON.dump(old_package))

say "Copying tsconfig.json to the Rails root directory for typescript"
copy_file "#{__dir__}/examples/#{example_source}/tsconfig.json", "tsconfig.json"

say "Updating webpack paths to include .ts file extension"
insert_into_file Webpacker.config.config_path, "- .ts\n".indent(4), after: /\s+extensions:\n/

say "Updating webpack paths to include .tsx file extension"
insert_into_file Webpacker.config.config_path, "- .tsx\n".indent(4), after: /\s+extensions:\n/

say "Copying the example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/typescript/hello_typescript.ts",
  "#{Webpacker.config.source_entry_path}/hello_typescript.ts"

say "Installing all typescript dependencies"
run "yarn add typescript #{additional_packages}"

say "Webpacker now supports typescript 🎉", :green
