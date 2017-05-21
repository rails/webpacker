// Note: You must restart bin/webpack-dev-server for changes to take effect

const merge = require('webpack-merge')
const sharedConfig = require('./shared.js')
const { dev_server, output } = require('./configuration.js')

module.exports = merge(sharedConfig, {
  devtool: 'cheap-module-source-map',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  devServer: {
    clientLogLevel: 'none',
    https: dev_server.https,
    host: dev_server.host,
    port: dev_server.port,
    contentBase: output.path,
    publicPath: output.publicPath,
    compress: true,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    watchOptions: {
      ignored: /node_modules/
    }
  }
})
