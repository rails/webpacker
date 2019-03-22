const { join } = require('path')
const TerserPlugin = require('terser-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const safePostCssParser = require('postcss-safe-parser')
const Base = require('./base')
const { cache_path: cachePath } = require('../config')

module.exports = class extends Base {
  constructor() {
    super()

    this.plugins.append(
      'Compression',
      new CompressionPlugin({
        filename: '[path].gz[query]',
        algorithm: 'gzip',
        cache: join(cachePath, 'compression-webpack-plugin'),
        test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
      })
    )

    this.plugins.append(
      'OptimizeCSSAssets',
      new OptimizeCSSAssetsPlugin({
        parser: safePostCssParser,
        map: {
          inline: false,
          annotation: true
        }
      })
    )

    this.config.merge({
      devtool: 'source-map',
      stats: 'normal',
      bail: true,
      optimization: {
        minimizer: [
          new TerserPlugin({
            parallel: true,
            cache: join(cachePath, 'terser-webpack-plugin'),
            sourceMap: true,
            terserOptions: {
              parse: {
                // Let terser parse ecma 8 code but always output
                // ES5 compliant code for older browsers
                ecma: 8
              },
              compress: {
                ecma: 5,
                warnings: false,
                comparisons: false
              },
              mangle: {
                safari10: true
              },
              output: {
                ecma: 5,
                comments: false,
                ascii_only: true
              }
            }
          })
        ]
      }
    })
  }
}
