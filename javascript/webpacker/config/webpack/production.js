// Note: You must run bin/webpack for changes to take effect

const CompressionPlugin = require('compression-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const merge = require('webpack-merge')
const webpack = require('webpack')
const sharedConfig = require('./shared')

module.exports = merge(sharedConfig, {
  devtool: 'source-map',
  stats: 'normal',
  output: { filename: '[name]-[chunkhash].js' },

  plugins: [
    new ExtractTextPlugin('[name]-[hash].css'),

    new webpack.optimize.UglifyJsPlugin({
      minimize: true,
      sourceMap: true,
      compress: {
        screw_ie8: true,
        warnings: false
      },
      mangle: {
        screw_ie8: true
      },
      output: {
        comments: false,
        screw_ie8: true
      }
    }),

    new CompressionPlugin({
      asset: '[path].gz[query]',
      algorithm: 'gzip',
      test: /\.(js|css|svg|eot|ttf|woff|woff2)$/
    })
  ]
})
