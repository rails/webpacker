/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { merge } = require('webpack-merge')
const CompressionPlugin = require('compression-webpack-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const baseConfig = require('./base')

const getPlugins = () => {
  let compressionPlugin = new CompressionPlugin({
    filename: '[path].gz[query]',
    algorithm: 'gzip',
    test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
  })

  if ('brotli' in process.versions) {
    compressionPlugin = new CompressionPlugin({
      filename: '[path].br[query]',
      algorithm: 'brotliCompress',
      test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
    })
  }

  const plugins = [compressionPlugin]

  try {
    if (require.resolve('css-loader')) {
      const OptimizeCSSAssetsPlugin = require.resolve(
        'optimize-css-assets-webpack-plugin'
      )
      const safePostCssParser = require.resolve('postcss-safe-parser')
      plugins.push(
        new OptimizeCSSAssetsPlugin({
          parser: safePostCssParser,
          map: {
            inline: false,
            annotation: true
          }
        })
      )
    }
  } catch (e) {
    /* Work out what to output without clutter */
  }

  return plugins
}

const productionConfig = {
  devtool: 'source-map',
  stats: 'normal',
  bail: true,
  plugins: getPlugins(),
  optimization: {
    minimizer: [
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
    ]
  }
}

module.exports = merge(baseConfig, productionConfig)
