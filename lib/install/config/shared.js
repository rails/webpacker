// Note: You must restart bin/webpack-watcher for changes to take effect

var webpack = require('webpack')
var path = require('path')
var process = require('process')
var glob = require('glob')
var extname = require('path-complete-extname')
var distPath = process.env.WEBPACK_DIST_PATH

if(distPath === undefined) {
  distPath = 'packs'
}

config = {
  entry: glob.sync(path.join('..', 'app', 'javascript', 'packs', '*.js*')).reduce(
    function(map, entry) {
      var basename = path.basename(entry, extname(entry))
      map[basename] = entry
      return map
    }, {}
  ),

  output: { filename: '[name].js', path: path.resolve('..', 'public', distPath) },

  module: {
    rules: [
      { test: /\.coffee(.erb)?$/, loader: "coffee-loader" },
      {
        test: /\.js(.erb)?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: [
            [ 'latest', { 'es2015': { 'modules': false } } ]
          ]
        }
      },
      {
        test: /.erb$/,
        enforce: 'pre',
        exclude: /node_modules/,
        loader: 'rails-erb-loader',
        options: {
          runner: 'DISABLE_SPRING=1 ../bin/rails runner'
        }
      },
    ]
  },

  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify(process.env.RAILS_ENV)
      }
    })
  ],

  resolve: {
    extensions: [ '.js', '.coffee' ],
    modules: [
      path.resolve('../app/javascript'),
      path.resolve('../vendor/node_modules')
    ]
  },

  resolveLoader: {
    modules: [ path.resolve('../vendor/node_modules') ]
  }
}

module.exports = {
  distPath: distPath,
  config: config
}
