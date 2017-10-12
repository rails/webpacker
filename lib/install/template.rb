# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

say "Copying webpack core config and loaders"
directory "#{__dir__}/config/webpack", "config/webpack"

say "Copying .postcssrc.yml to app root directory"
copy_file "#{__dir__}/config/.postcssrc.yml", ".postcssrc.yml"

say "Copying .babelrc to app root directory"
copy_file "#{__dir__}/config/.babelrc", ".babelrc"

say "Creating JavaScript app source directory"
directory "#{__dir__}/javascript", Webpacker.config.source_path

say "Installing binstubs"
run "bundle binstubs webpacker"

if File.exists?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/public/packs
/public/packs-test
/node_modules
EOS
end

say "Installing all JavaScript dependencies"
run "yarn add @rails/webpacker coffeescript@1.12.7"

say "Installing dev server for live reloading"
run "yarn add --dev webpack-dev-server"

say "Webpacker successfully installed 🎉 🍰", :green
