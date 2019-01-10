require "webpacker/configuration"

say "Copying the example test files"
tests_folder = "#{defined?(RSpec) ? 'spec' : 'test'}/javascripts"

copy_file "#{__dir__}/examples/jest/hello_jest.js",
          "#{Webpacker.config.source_entry_path}/hello_jest.js"
copy_file "#{__dir__}/examples/jest/hello_jest.spec.js",
          "#{Webpacker.config.root_path.join(tests_folder)}/hello_jest.spec.js"

say "Updating package.json"
package_json = JSON.parse(File.read(Rails.root.join("package.json")))
relative_source_path = Webpacker.config.source_path.relative_path_from(Webpacker.config.root_path)

jest_config = {
  "scripts" => {
    "test" => "jest",
    "test:watch" => "jest --watch"
  },
  "jest" => {
    "roots" => [relative_source_path.to_s, tests_folder],
    "moduleDirectories" => ["node_modules", relative_source_path.to_s],
    "transform" => {
      "^.+\\.js?$" => "babel-jest"
    }
  }
}

order_list = %w(name private jest dependencies devDependencies)
new_package_json = jest_config.deep_merge(package_json).sort_by do |key, value|
  order_list.index(key) || Float::INFINITY
end.to_h

File.write(Rails.root.join("package.json"), JSON.pretty_generate(new_package_json))

say "Installing all Jest dependencies"
run "yarn add --dev jest babel-jest"

say "Webpacker now supports Jest 🎉. Execute 'yarn test' to run your tests.", :green
