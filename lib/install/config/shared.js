// Note: You must restart bin/webpack-watcher for changes to take effect

var path = require('path')
var glob = require('glob')
var extname = require('path-complete-extname')

module.exports = {
  entry: glob.sync(path.join('..', 'app', 'javascript', 'packs', '*.js*')).reduce(
    function(map, entry) {
      basename = path.basename(entry, extname(entry))
      map[basename] = entry;
      return map;
    }, {}
  ),

  output: { filename: '[name].js', path: path.join('..', 'public', 'packs') },

  module: {
    loaders: [
      { test: /\.coffee(.erb)?$/, loader: "coffee-loader" },
      {
        test: /\.js(.erb)?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          presets: ['es2015']
        }
      }
    ],

    preLoaders: [
      {
        test: /\.erb$/,
        loader: 'rails-erb-loader',
        query: {
          runner: '../bin/rails runner'
        }
      },
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
