// Note: You must restart bin/webpack-watcher for changes to take effect

const webpack = require('webpack')
const path = require('path')
const process = require('process')
const glob = require('glob')
const extname = require('path-complete-extname')
let distDir = process.env.WEBPACK_DIST_DIR

if (distDir === undefined) {
  distDir = 'packs'
}

config = {
  entry: glob.sync(path.join('app', 'javascript', 'packs', '*.js*')).reduce((map, entry) => {
    const basename = path.basename(entry, extname(entry))
    map[basename] = path.resolve(entry)
    return map
  }, {}),

  output: { filename: '[name].js', path: path.resolve('public', distDir) },

  module: {
    rules: [
      { test: /\.coffee(\.erb)?$/, loader: "coffee-loader" },
      {
        test: /\.js(\.erb)?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: [
            [ 'latest', { 'es2015': { 'modules': false } } ]
          ]
        }
      },
      {
        test: /\.erb$/,
        enforce: 'pre',
        exclude: /node_modules/,
        loader: 'rails-erb-loader',
        options: {
          runner: 'DISABLE_SPRING=1 bin/rails runner'
        }
      },
    ]
  },

  plugins: [
    new webpack.EnvironmentPlugin(Object.keys(process.env))
  ],

  resolve: {
    extensions: [ '.js', '.coffee' ],
    modules: [
      path.resolve('app/javascript'),
      path.resolve('node_modules')
    ]
  },

  resolveLoader: {
    modules: [ path.resolve('node_modules') ]
  }
}

module.exports = {
  distDir: distDir,
  config: config
}
