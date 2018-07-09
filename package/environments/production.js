const webpack = require('webpack')
const CompressionPlugin = require('compression-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const Base = require('./base')

module.exports = class extends Base {
  constructor() {
    super()

    this.plugins.append('ModuleConcatenation', new webpack.optimize.ModuleConcatenationPlugin())
    this.plugins.append('OptimizeCSSAssets', new OptimizeCSSAssetsPlugin())

    this.plugins.append(
      'UglifyJs',
      new UglifyJsPlugin({
        parallel: true,
        cache: true,
        sourceMap: true,
        uglifyOptions: {
          parse: {
            // Let uglify-js parse ecma 8 code but always output
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
    )

    this.plugins.append(
      'Compression',
      new CompressionPlugin({
        asset: '[path].gz[query]',
        algorithm: 'gzip',
        test: /\.(js|css|html|json|ico|svg|eot|otf|ttf)$/
      })
    )

    this.config.merge({
      devtool: 'nosources-source-map',
      stats: 'normal'
    })
  }
}
