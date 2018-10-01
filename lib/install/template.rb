# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

puts "Copying webpack core config"
directory "#{__dir__}/config/webpack", "config/webpack"

say "Copying .postcssrc.yml to app root directory"
copy_file "#{__dir__}/config/.postcssrc.yml", ".postcssrc.yml"

say "Copying .babelrc to app root directory"
copy_file "#{__dir__}/config/.babelrc", ".babelrc"

say "Copying .browserslistrc to app root directory"
copy_file "#{__dir__}/config/.browserslistrc", ".browserslistrc"

if Dir.exists?(Webpacker.config.source_path)
  say "The JavaScript app source directory already exists"
else
  say "Creating JavaScript app source directory"
  directory "#{__dir__}/javascript", Webpacker.config.source_path
end

apply "#{__dir__}/binstubs.rb"

if File.exists?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/public/packs
/public/packs-test
/node_modules
yarn-debug.log*
.yarn-integrity
EOS
end

if Webpacker::VERSION == /^[0-9]+\.[0-9]+\.[0-9]+$/
  say "Installing all JavaScript dependencies [#{Webpacker::VERSION}]"
  run "yarn add @rails/webpacker"
else
  say "Installing all JavaScript dependencies [from prerelease rails/webpacker]"
  run "yarn add https://github.com/rails/webpacker"
end

say "Installing dev server for live reloading"
run "yarn add --dev webpack-dev-server"

if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR > 1
  say "You need to allow webpack-dev-server host as allowed origin for connect-src.", :yellow
  say "This can be done in Rails 5.2+ for development environment in the CSP initializer", :yellow
  say "config/initializers/content_security_policy.rb with a snippet like this:", :yellow
  say "policy.connect_src :self, :https, \"http://localhost:3035\", \"ws://localhost:3035\" if Rails.env.development?", :yellow
end

say "Webpacker successfully installed 🎉 🍰", :green
