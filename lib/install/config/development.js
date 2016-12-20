// Note: You must restart bin/webpack-watcher for changes to take effect

var path    = require('path')
var webpack = require('webpack')
var merge   = require('webpack-merge')

var config = require('./shared.js')

module.exports = merge(config, {
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
