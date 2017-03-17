# Setup webpacker
directory "#{__dir__}/javascript", "app/javascript"

directory "#{__dir__}/bin", "bin"
chmod "bin", 0755 & ~File.umask, verbose: false

directory "#{__dir__}/config/webpack", "config/webpack"

append_to_file ".gitignore", <<-EOS
/public/packs
/node_modules
EOS

run "./bin/yarn add webpack webpack-merge js-yaml path-complete-extname " \
"webpack-manifest-plugin babel-loader coffee-loader coffee-script " \
"babel-core babel-preset-env compression-webpack-plugin rails-erb-loader glob " \
"extract-text-webpack-plugin node-sass file-loader sass-loader css-loader style-loader"

run "./bin/yarn add --dev webpack-dev-server"
