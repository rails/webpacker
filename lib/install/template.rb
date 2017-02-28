directory "#{__dir__}/javascript", 'app/javascript'

directory "#{__dir__}/bin", 'bin'
chmod 'bin', 0755 & ~File.umask, verbose: false

directory "#{__dir__}/config", 'config/webpack'

append_to_file '.gitignore', <<-EOS
/public/packs
/node_modules
EOS

run './bin/yarn add webpack webpack-merge path-complete-extname babel-loader babel-core babel-preset-latest coffee-loader coffee-script compression-webpack-plugin rails-erb-loader glob'
run './bin/yarn add --dev webpack-dev-server'

environment \
  "# Make javascript_pack_tag lookup digest hash to enable long-term caching\n" +
  "  config.x.webpacker[:digesting] = true\n",
  env: 'production'

environment \
  "# Make javascript_pack_tag load assets from webpack-dev-server.\n" +
  "  # config.x.webpacker[:dev_server_host] = \"http://localhost:8080\"\n",
  env: 'development'
