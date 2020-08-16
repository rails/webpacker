const WebpackAssetsManifest = require('webpack-assets-manifest')
const config = require('../config')

module.exports = new WebpackAssetsManifest({
  entrypoints: true,
  writeToDisk: true,
  publicPath: config.publicPathWithoutCDN
})
