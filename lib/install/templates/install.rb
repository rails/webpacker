# Setup webpacker

directory "#{File.expand_path("..", __dir__)}/node", "./"
directory "#{File.expand_path("..", __dir__)}/javascript", "app/javascript"

directory "#{File.expand_path("..", __dir__)}/bin", "bin"
chmod "bin", 0755 & ~File.umask, verbose: false

directory "#{File.expand_path("..", __dir__)}/config/webpack", "config/webpack"

append_to_file ".gitignore", <<-EOS
/public/packs
/node_modules
EOS

run "./bin/yarn add webpack webpack-merge path-complete-extname " \
"webpack-manifest-plugin babel-loader coffee-loader coffee-script " \
"babel-core babel-preset-env compression-webpack-plugin rails-erb-loader glob"

run "./bin/yarn add --dev webpack-dev-server"
