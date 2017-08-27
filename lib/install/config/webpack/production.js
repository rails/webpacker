// Note: You must restart bin/webpack-dev-server for changes to take effect

/* eslint global-require: 0, no-console: 0 */

const webpack = require('webpack')
const merge = require('webpack-merge')
const { resolve } = require('path')
const CompressionPlugin = require('compression-webpack-plugin')
const SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin')
const sharedConfig = require('./shared.js')
const { env } = require('./configuration.js')

module.exports = merge(sharedConfig, {
  devtool: 'source-map',
  stats: 'normal',

  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,

      compress: {
        warnings: false
      },

      output: {
        comments: false
      }
    }),

    new CompressionPlugin({
      asset: '[path].gz[query]',
      algorithm: 'gzip',
      test: /\.(js|css|html|json|ico|svg|eot|otf|ttf)$/
    }),

    new SWPrecacheWebpackPlugin({
      dontCacheBustUrlsMatching: /\.\w{8}\./,
      minify: true,
      logger(message) {
        // Hide noise
        if (message.indexOf('Total precache size is') === 0) return
        if (message.indexOf('Skipping static resource') === 0) return
        console.log(message)
      },
      filepath: resolve('public', 'service-worker.js'),
      navigateFallback: `${env.PUBLIC_URL}/index.html`,
      staticFileGlobsIgnorePatterns: [/\.map$/, /manifest\.json$/]
    })
  ]
})
