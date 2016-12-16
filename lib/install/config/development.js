// Note: You must restart bin/webpack-watcher for changes to take effect

var path    = require('path')
var webpack = require('webpack')
var merge   = require('webpack-merge')

var config = require('./shared.js')

module.exports = merge(config, {
  displayErrorDetails: true,
  outputPathinfo: true,
  devtool: 'sourcemap',

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ]
});
