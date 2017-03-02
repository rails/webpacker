// Note: You must restart bin/webpack-dev-server for changes to take effect

const merge = require('webpack-merge')
const devConfig = require('./development.js')
const sharedConfig = require('./shared.js')
const { devServer } = require('../../package.json')

module.exports = merge(devConfig, {
  devServer: {
    host: devServer.host,
    port: devServer.port,
    compress: devServer.compress,
    publicPath: devServer.enabled ?
      `http://${devServer.host}:${devServer.port}/` : `/${sharedConfig.distDir}/`
  }
})
