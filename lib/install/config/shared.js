// Note: You must restart bin/webpack-watcher for changes to take effect

var path = require('path')
var glob = require('glob')
var _    = require('lodash')

module.exports = {
  entry: _.keyBy(glob.sync(path.join('..', 'app', 'packs', 'javascripts', '*.js')),
    function(entry) { return path.basename(entry, '.js') }),

  output: { filename: '[name].js', path: path.join('..', 'public', 'packs') },

  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee-loader" }
    ]
  },

  plugins: [],

  resolve: {
    extensions: [ '', '.js', '.coffee' ],
    root: [
      path.resolve('../app/javascript'),
      path.resolve('../vendor/node_modules')
    ]
  },

  resolveLoader: {
    modulesDirectories: [ path.resolve('../vendor/node_modules') ]
  }
}
