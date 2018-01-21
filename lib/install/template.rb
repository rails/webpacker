# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

puts "Copying webpack core config"
directory "#{__dir__}/config/webpack", "config/webpack"

say "Copying .postcssrc.yml to app root directory"
copy_file "#{__dir__}/config/.postcssrc.yml", ".postcssrc.yml"

say "Copying .babelrc to app root directory"
copy_file "#{__dir__}/config/.babelrc", ".babelrc"

say "Creating JavaScript app source directory"
directory "#{__dir__}/javascript", Webpacker.config.source_path

say "Installing binstubs"
run "bundle binstubs webpacker"

say "Adding configurations"

# Verifies that versions and hashed value of the package contents in the project's package.json
inject_into_file "config/environments/development.rb", "    config.webpacker.check_yarn_integrity = true", after: "Rails.application.configure do\n", verbose: false
inject_into_file "config/environments/production.rb", "   config.webpacker.check_yarn_integrity = false", after: "Rails.application.configure do\n", verbose: false

if File.exists?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/public/packs
/public/packs-test
/node_modules
yarn-debug.log*
yarn-error.log*
.yarn-integrity
EOS
end

say "Installing all JavaScript dependencies"
run "yarn add @rails/webpacker"

say "Installing dev server for live reloading"
run "yarn add --dev webpack-dev-server"

say "Webpacker successfully installed 🎉 🍰", :green
