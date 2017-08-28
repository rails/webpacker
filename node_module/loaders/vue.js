const { dev_server } = require('../config')

const isProduction = process.env.NODE_ENV === 'production'
const extractCSS = !(dev_server && dev_server.hmr)

module.exports = {
  test: /\.vue$/,
  loader: 'vue-loader',
  options: {
    extractCSS: isProduction || extractCSS
  }
}
