INSTALL_PATH = File.dirname(__FILE__)

directory "#{INSTALL_PATH}/javascript", 'app/javascript'

directory "#{INSTALL_PATH}/bin", 'bin'
chmod 'bin', 0755 & ~File.umask, verbose: false

directory "#{INSTALL_PATH}/config", 'config/webpack'

run './bin/yarn add webpack lodash'

environment \
  "# Make javascript_pack_tag lookup digest hash to enable long-term caching\n" +
  "  config.x.webpacker[:digesting] = true\n",
  env: 'production'
