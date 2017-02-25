// Note: You must restart bin/webpack-watcher for changes to take effect

const webpack = require('webpack')
const merge   = require('webpack-merge')

const sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig.config, {
  devtool: 'sourcemap',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true,
    // Make sure additional assets are loaded through webpack-dev-server
    // publicPath: 'http://localhost:8080/'
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ]
})
