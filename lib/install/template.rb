# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

say "Copying webpack core config"
directory "#{__dir__}/config/webpack", "config/webpack"

say "Copying postcss.config.js to app root directory"
copy_file "#{__dir__}/config/postcss.config.js", "postcss.config.js"

say "Copying babel.config.js to app root directory"
copy_file "#{__dir__}/config/babel.config.js", "babel.config.js"

say "Copying .browserslistrc to app root directory"
copy_file "#{__dir__}/config/.browserslistrc", ".browserslistrc"

if Dir.exist?(Webpacker.config.source_path)
  say "The JavaScript app source directory already exists"
else
  say "Creating JavaScript app source directory"
  directory "#{__dir__}/javascript", Webpacker.config.source_path
end

apply "#{__dir__}/binstubs.rb"

if File.exist?(".gitignore")
  append_to_file ".gitignore" do
    "\n"                   +
    "/public/packs\n"      +
    "/public/packs-test\n" +
    "/node_modules\n"      +
    "/yarn-error.log\n"    +
    "yarn-debug.log*\n"    +
    ".yarn-integrity\n"
  end
end

if Webpacker::VERSION.match?(/^[0-9]+\.[0-9]+\.[0-9]+$/)
  say "Installing all JavaScript dependencies [#{Webpacker::VERSION}]"
  run "yarn add @rails/webpacker@#{Webpacker::VERSION}"
else
  say "Installing all JavaScript dependencies [from prerelease rails/webpacker]"
  run "yarn add @rails/webpacker@next"
end

package_json = File.read("#{__dir__}/../../package.json")
webpack_version = package_json.match(/"webpack": "(.*)"/)[1]
webpack_cli_version = package_json.match(/"webpack-cli": "(.*)"/)[1]

# needed for experimental Yarn 2 support and should not harm Yarn 1
say "Installing webpack and webpack-cli as direct dependencies"
run "yarn add webpack@#{webpack_version} webpack-cli@#{webpack_cli_version}"

say "Installing dev server for live reloading"
run "yarn add --dev webpack-dev-server@^3"

if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR > 1
  say "You need to allow webpack-dev-server host as allowed origin for connect-src.", :yellow
  say "This can be done in Rails 5.2+ for development environment in the CSP initializer", :yellow
  say "config/initializers/content_security_policy.rb with a snippet like this:", :yellow
  say "policy.connect_src :self, :https, \"http://localhost:3035\", \"ws://localhost:3035\" if Rails.env.development?", :yellow
end

say "Webpacker successfully installed 🎉 🍰", :green
