// Note: You must restart bin/webpack-watcher for changes to take effect

var webpack = require('webpack')
var merge   = require('webpack-merge')

var sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig.config, {
  devtool: 'sourcemap',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ]
})
