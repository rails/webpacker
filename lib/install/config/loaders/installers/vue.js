const ExtractTextPlugin = require('extract-text-webpack-plugin')
const { env } = require('../configuration.js')

module.exports = {
  test: /\.vue$/,
  loader: 'vue-loader',
  options: {
    extractCSS: env.NODE_ENV === 'production'
  }
}
