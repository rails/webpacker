const { join } = require('path')
const { settings } = require('../configuration.js')

module.exports = {
  test: /\.(js|jsx)?(\.erb)?$/,
  exclude: /node_modules/,
  loader: 'babel-loader',
  options: {
    cacheDirectory: join(settings.cache_path, 'babel-loader')
  }
}
