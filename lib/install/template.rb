INSTALL_PATH = File.dirname(__FILE__)

directory "#{INSTALL_PATH}/javascript", 'app/javascript'

directory "#{INSTALL_PATH}/bin", 'bin'
chmod 'bin', 0755 & ~File.umask, verbose: false

directory "#{INSTALL_PATH}/config", 'config/webpack'

append_to_file '.gitignore', <<-EOS

# Ignore files compiled by webpacker.
public/packs/*
/vendor/node_modules/*
EOS

run './bin/yarn add --dev webpack@beta webpack-merge webpack-bundle-tracker path-complete-extname babel-loader babel-core babel-preset-latest coffee-loader coffee-script rails-erb-loader'

environment \
  "# Make javascript_pack_tag lookup digest hash to enable long-term caching\n" +
  "  config.x.webpacker[:digesting] = true\n",
  env: 'production'
