# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

say "Copying webpack core config"
directory "#{__dir__}/config/webpack", "config/webpack"

say "Copying postcss.config.js to app root directory"
copy_file "#{__dir__}/config/postcss.config.js", "postcss.config.js"

if Dir.exists?(Webpacker.config.source_path)
  say "The JavaScript app source directory already exists"
else
  say "Creating JavaScript app source directory"
  directory "#{__dir__}/javascript", Webpacker.config.source_path
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

Dir.chdir(Rails.root) do
  if Webpacker::VERSION =~ /^[0-9]+\.[0-9]+\.[0-9]+$/
    say "Installing all JavaScript dependencies [#{Webpacker::VERSION}]"
    run "yarn add @rails/webpacker@#{Webpacker::VERSION}"
  else
    say "Installing all JavaScript dependencies [from prerelease rails/webpacker]"
    run "yarn add @rails/webpacker@next"
  end

  say "Installing dev server for live reloading"
  run "yarn add --dev webpack-dev-server"
end

insert_into_file Rails.root.join("package.json").to_s, before: /\n}\n*$/ do
  <<~JSON.chomp
  ,
    "babel": {
      "presets": ["./node_modules/@rails/webpacker/package/babel/preset.js"]
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

say "Webpacker successfully installed 🎉 🍰", :green
