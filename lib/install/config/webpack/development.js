// Note: You must restart bin/webpack-dev-server for changes to take effect

const merge = require('webpack-merge')
const sharedConfig = require('./shared.js')
const { resolve } = require('path')
const { devServer, publicPath, paths } = require('./configuration.js')

module.exports = merge(sharedConfig, {
  devtool: 'sourcemap',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  devServer: {
    host: devServer.host,
    port: devServer.port,
    compress: true,
    https: devServer.https,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    contentBase: resolve(paths.output, paths.entry),
    publicPath
  }
})
