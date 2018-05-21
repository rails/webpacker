const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin')
const Base = require('./base')

module.exports = class extends Base {
  constructor() {
    super()

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
      stats: 'normal',
      bail: true,
      optimization: {
        minimizer: [
          new UglifyJsPlugin({
            parallel: true,
            cache: true,
            sourceMap: true,
            uglifyOptions: {
              ecma: 5,
              compress: {
                warnings: false,
                comparisons: false
              },
              mangle: {
                safari10: true
              },
              output: {
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
