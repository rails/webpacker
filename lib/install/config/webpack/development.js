// Note: You must restart bin/webpack-dev-server for changes to take effect

const merge = require('webpack-merge')
const { readFileSync } = require('fs')
const sharedConfig = require('./shared.js')
const { settings, output } = require('./configuration.js')

const { dev_server: devServer } = settings
let https = devServer.https

// Set ssl key and certificates if supplied
if (devServer.ssl_key_path && devServer.ssl_cert_path) {
  https = {
    key: readFileSync(devServer.ssl_key_path),
    cert: readFileSync(devServer.ssl_cert_path)
  }
}

module.exports = merge(sharedConfig, {
  devtool: 'cheap-eval-source-map',

  output: {
    pathinfo: true
  },

  devServer: {
    clientLogLevel: 'none',
    https,
    host: devServer.host,
    port: devServer.port,
    contentBase: output.path,
    publicPath: output.publicPath,
    compress: true,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    watchOptions: {
      ignored: /node_modules/
    },
    stats: {
      errorDetails: true
    }
  }
})
