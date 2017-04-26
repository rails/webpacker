// Note: You must restart bin/webpack-watcher for changes to take effect

const webpack = require('webpack')
const merge = require('webpack-merge')
const sharedConfig = require('./shared')
const { devServer, outputPath, publicPath } = require('../index')

module.exports = merge(sharedConfig, {
  devtool: 'cheap-module-source-map',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  devServer: {
    // Show only compile warnings and errors.
    clientLogLevel: 'none',
    compress: true,
    contentBase: outputPath,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    host: devServer.host,
    // Optional HMR support - https://webpack.js.org/concepts/hot-module-replacement/
    // Works with JS, CSS and Vue out-of-the-box
    // More info on integrating HMR with React: https://webpack.js.org/guides/hmr-react/
    hot: devServer.hot,
    // Enable HTTPS if the protocol is https
    https: devServer.protocol === 'https',
    inline: true,
    port: devServer.port,
    publicPath,
    // Disable logs
    quiet: devServer.quiet,
    // Avoids CPU overload on some systems.
    watchOptions: {
      ignored: /node_modules/
    }
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin()
  ]
})
