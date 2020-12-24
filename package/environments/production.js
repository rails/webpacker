/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { merge } = require('webpack-merge')
const CompressionPlugin = require('compression-webpack-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const baseConfig = require('./base')
const { moduleExists } = require('../utils/helpers')

const getPlugins = () => {
  let compressionPlugin = new CompressionPlugin({
    filename: '[path][base].gz[query]',
    algorithm: 'gzip',
    test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
  })

  if ('brotli' in process.versions) {
    compressionPlugin = new CompressionPlugin({
      filename: '[path][base].br[query]',
      algorithm: 'brotliCompress',
      test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
    })
  }

  return [compressionPlugin]
}

const productionConfig = {
  devtool: 'source-map',
  stats: 'normal',
  bail: true,
  plugins: getPlugins(),
  optimization: {
    minimizer: [
      () => {
        if (
          moduleExists('css-loader') &&
          moduleExists('css-minimizer-webpack-plugin')
        ) {
          const CssMinimizerPlugin = require('css-minimizer-webpack-plugin')
          return new CssMinimizerPlugin({ sourceMap: true })
        }

        return false
      },

      new TerserPlugin({
        parallel: Number.parseInt(process.env.WEBPACKER_PARALLEL, 10) || true,
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
          mangle: { safari10: true },
          output: {
            ecma: 5,
            comments: false,
            ascii_only: true
          }
        }
      })
    ].filter(Boolean)
  }
}

module.exports = merge(baseConfig, productionConfig)
