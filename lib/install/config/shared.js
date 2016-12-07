// Note: You must restart bin/webpack-watcher for changes to take effect

var path = require('path')
var glob = require('glob')

module.exports = {
  entry: glob.sync(path.join('..', 'app', 'javascript', 'packs', '*.js')).reduce(
    function(map, entry) {
      basename = path.basename(entry, '.js')
      map[basename] = entry;
      return map;
    }, {}
  ),

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
