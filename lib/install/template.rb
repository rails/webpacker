# Install Webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"
copy_file "#{__dir__}/package.json", "package.json"

say "Copying webpack core config"
directory "#{__dir__}/config/webpack", "config/webpack"

if Dir.exist?(Webpacker.config.source_path)
  say "The packs app source directory already exists"
else
  say "Creating packs app source directory"
  empty_directory "app/javascript"
  copy_file "#{__dir__}/application.js", "app/javascript/application.js"
end

apply "#{__dir__}/binstubs.rb"

git_ignore_path = Rails.root.join(".gitignore")
if File.exist?(git_ignore_path)
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

if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
  say "Add JavaScript include tag in application layout"
  insert_into_file app_layout_path.to_s, %(\n    <%= javascript_pack_tag "application" %>), before: /\s*<\/head>/
else
  say "Default application.html.erb is missing!", :red
  say %(        Add <%= javascript_pack_tag "application" %> within the <head> tag in your custom layout.)
end

if (setup_path = Rails.root.join("bin/setup")).exist?
  say "Run bin/yarn during bin/setup"
  insert_into_file setup_path.to_s, <<-RUBY, after: %(  system("bundle check") || system!("bundle install")\n)

  # Install JavaScript dependencies
  system! "bin/yarn"
RUBY
end

if (asset_config_path = Rails.root.join("config/initializers/assets.rb")).exist?
  say "Add node_modules to the asset load path"
  append_to_file asset_config_path, <<-RUBY

# Add node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")
RUBY
end

if (csp_config_path = Rails.root.join("config/initializers/content_security_policy.rb")).exist?
  say "Make note of webpack-dev-server exemption needed to csp"
  insert_into_file csp_config_path, <<-RUBY, after: %(# Rails.application.config.content_security_policy do |policy|)
  #   # If you are using webpack-dev-server then specify webpack-dev-server host
  #   policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
RUBY
end

results = []

Dir.chdir(Rails.root) do
  if Webpacker::VERSION.match?(/^[0-9]+\.[0-9]+\.[0-9]+$/)
    say "Installing @rails/webpacker@#{Webpacker::VERSION}"
    results << run("yarn add @rails/webpacker@#{Webpacker::VERSION}")
  else
    say "Installing @rails/webpacker@next"
    results << run("yarn add @rails/webpacker@next")
  end

  package_json = File.read("#{__dir__}/../../package.json")
  peers = JSON.parse(package_json)["peerDependencies"]
  peers_to_add = peers.reduce([]) do |result, (package, version)|
    major_version = version.match(/(\d+)/)[1]
    result << "#{package}@#{major_version}"
  end.join(" ")

  say "Adding @rails/webpacker peerDependencies"
  results << run("yarn add #{peers_to_add}")

  say "Installing webpack-dev-server for live reloading as a development dependency"
  results << run("yarn add --dev webpack-dev-server")
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
