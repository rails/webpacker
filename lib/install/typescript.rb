require "webpacker/configuration"

additional_packages = ""
example_source = "typescript"

# Additional configuration is required for React projects
package_json = Rails.root.join("package.json")
if File.exist?(package_json)
  package = JSON.parse(File.read(package_json))
  package["dependencies"] ||= {}

  if package["dependencies"].key?("react")
    additional_packages = "@types/react @types/react-dom"
    example_source = "react"
  end
end

say "Adding TypeScript preset to babel.config.js"
insert_into_file Rails.root.join("babel.config.js").to_s,
  ",\n      ['@babel/preset-typescript', { 'allExtensions': true, 'isTSX': true }]",
  before: /\s*\].filter\(Boolean\),\n\s*plugins: \[/

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
run "yarn add typescript @babel/preset-typescript #{additional_packages}"

say "Webpacker now supports typescript 🎉", :green
