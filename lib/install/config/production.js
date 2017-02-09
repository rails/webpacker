// Note: You must restart bin/webpack-watcher for changes to take effect

var webpack = require('webpack')
var merge   = require('webpack-merge')

var config = require('./shared.js')

module.exports = merge(config, {
  output: { filename: '[name]-[hash].js' },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ]
})
