const { env, settings } = require('../configuration.js')

const isProduction = env.NODE_ENV === 'production'
const extractCSS = !(settings.dev_server && settings.dev_server.hmr)

module.exports = {
  test: /\.vue$/,
  loader: 'vue-loader',
  options: {
    extractCSS: isProduction || extractCSS
  }
}
