// Note: You must restart bin/webpack-dev-server for changes to take effect

const path = require('path')
const merge = require('webpack-merge')
const devConfig = require('./development.js')
const { dev_server, publicPath, paths } = require('./configuration.js')

module.exports = merge(devConfig, {
  devServer: {
    host: dev_server.host,
    port: dev_server.port,
    compress: true,
    historyApiFallback: true,
    contentBase: path.resolve(paths.dist_path),
    publicPath
  }
})
