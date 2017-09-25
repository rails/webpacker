const { join } = require('path')
const { cache_path, babel } = require('../config')

module.exports = {
  test: /\.(js|jsx)?(\.erb)?$/,
  exclude: (babel.exclude_node_modules ? /node_modules/ : []),
  loader: 'babel-loader',
  options: {
    cacheDirectory: join(cache_path, 'babel-loader')
  }
}
