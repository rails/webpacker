# Ensure yarn exists before proceeding with any yarn calls
run './bin/yarn --version'
unless $?.success?
  puts set_color "rails webpacker:install failed!", :red
  exit $?.exitstatus
end

directory "#{__dir__}/javascript", 'app/javascript'

directory "#{__dir__}/bin", 'bin'
chmod 'bin', 0755 & ~File.umask, verbose: false

directory "#{__dir__}/config", 'config/webpack'

append_to_file '.gitignore', <<-EOS
/public/packs
/node_modules
EOS

run './bin/yarn add webpack webpack-merge path-complete-extname babel-loader babel-core babel-preset-env coffee-loader coffee-script compression-webpack-plugin rails-erb-loader glob'
unless $?.success?
  puts set_color 'Failed to install webpack!', :red
  exit $?.exitstatus
end

run './bin/yarn add --dev webpack-dev-server'
unless $?.success?
  puts set_color 'Failed to install webpack-dev-server!', :red
  exit $?.exitstatus
end

environment \
  "# Make javascript_pack_tag lookup digest hash to enable long-term caching\n" +
  "  config.x.webpacker[:digesting] = true\n",
  env: 'production'

environment \
  "# Make javascript_pack_tag load assets from webpack-dev-server.\n" +
  "  # config.x.webpacker[:dev_server_host] = \"http://localhost:8080\"\n",
  env: 'development'
