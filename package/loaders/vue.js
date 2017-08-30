const config = require('../config')

const isProduction = process.env.NODE_ENV === 'production'
const extractCSS = !(config.dev_server && config.dev_server.hmr)

module.exports = {
  test: /\.vue(\.erb)?$/,
  loader: 'vue-loader',
  options: {
    extractCSS: isProduction || extractCSS
  }
}
