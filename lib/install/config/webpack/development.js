// Note: You must restart bin/webpack-dev-server for changes to take effect

const webpack = require('webpack')
const merge = require('webpack-merge')
const sharedConfig = require('./shared.js')
const { settings, output } = require('./configuration.js')

const { dev_server: devServer } = settings

module.exports = merge(sharedConfig, {
  devtool: 'cheap-eval-source-map',

  output: {
    pathinfo: true
  },

  devServer: {
    clientLogLevel: 'none',
    host: devServer.host,
    port: devServer.port,
    https: devServer.https,
    hot: devServer.hmr,
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
  },

  plugins: settings.dev_server.hmr ? [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin()
  ] : []
})
