# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

say "Copying webpack core config"
directory "#{__dir__}/config/webpack", "config/webpack"

if Dir.exists?(Webpacker.config.source_path)
  say "The packs app source directory already exists"
else
  say "Creating packs app source directory"
  directory "#{__dir__}/packs", Webpacker.config.source_path
end

apply "#{__dir__}/binstubs.rb"

git_ignore_path = Rails.root.join(".gitignore")
if File.exists?(git_ignore_path)
  append_to_file git_ignore_path do
    "\n"                   +
    "/public/packs\n"      +
    "/public/packs-test\n" +
    "/node_modules\n"      +
    "/yarn-error.log\n"    +
    "yarn-debug.log*\n"    +
    ".yarn-integrity\n"
  end
end

results = []

Dir.chdir(Rails.root) do
  if Webpacker::VERSION.match?(/^[0-9]+\.[0-9]+\.[0-9]+$/)
    say "Installing all JavaScript dependencies [#{Webpacker::VERSION}]"
    results << run("yarn add @rails/webpacker@#{Webpacker::VERSION}")
  else
    say "Installing all JavaScript dependencies [from prerelease rails/webpacker]"
    results << run("yarn add @rails/webpacker@next")
  end

  package_json = File.read("#{__dir__}/../../package.json")
  webpack_version = package_json.match(/"webpack": "(.*)"/)[1]
  webpack_cli_version = package_json.match(/"webpack-cli": "(.*)"/)[1]

  # needed for experimental Yarn 2 support and should not harm Yarn 1
  say "Installing webpack and webpack-cli as direct dependencies"
  results << run("yarn add webpack@#{webpack_version} webpack-cli@#{webpack_cli_version}")

  say "Installing dev server for live reloading"
  results << run("yarn add --dev webpack-dev-server @webpack-cli/serve")
end

insert_into_file Rails.root.join("package.json").to_s, before: /\n}\n*$/ do
  <<~JSON.chomp
  ,
    "babel": {
      "presets": [
        "./node_modules/@rails/webpacker/package/babel/preset.js"
      ]
    },
    "browserslist": [
      "defaults"
    ]
  JSON
end

if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR > 1
  say "You need to allow webpack-dev-server host as allowed origin for connect-src.", :yellow
  say "This can be done in Rails 5.2+ for development environment in the CSP initializer", :yellow
  say "config/initializers/content_security_policy.rb with a snippet like this:", :yellow
  say "policy.connect_src :self, :https, \"http://localhost:3035\", \"ws://localhost:3035\" if Rails.env.development?", :yellow
end

unless results.all?
  say "Webpacker installation failed 😭 See above for details.", :red
  exit 1
end
