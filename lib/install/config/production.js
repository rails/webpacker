// Note: You must restart bin/webpack-watcher for changes to take effect

var path    = require('path')
var webpack = require('webpack')
var _       = require('lodash')

var config = module.exports = require('./shared.js');

config.output = _.merge(config.output, { filename: '[name]-[hash].js' })

config.plugins.push(
  new webpack.optimize.UglifyJsPlugin(),
  new webpack.optimize.OccurenceOrderPlugin()
)
