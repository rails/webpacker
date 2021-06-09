/* eslint global-require: 0 */

const devServer = require('../dev_server')
const { canProcess, moduleExists, runningWebpackDevServer } = require('./helpers')

const getStyleRule = (test, preprocessors = []) => {
  if (moduleExists('css-loader')) {
    const tryPostcss = () =>
      canProcess('postcss-loader', (loaderPath) => ({
        loader: loaderPath,
        options: { sourceMap: true }
      }))

    // style-loader is required when using css modules with HMR on the webpack-dev-server
    const cssInline = runningWebpackDevServer && devServer.hmr

    const use = [
      cssInline ? 'style-loader' : require('mini-css-extract-plugin').loader,
      {
        loader: require.resolve('css-loader'),
        options: {
          sourceMap: true,
          importLoaders: 2
        }
      },
      tryPostcss(),
      ...preprocessors
    ].filter(Boolean)

    return {
      test,
      use
    }
  }

  return null
}

module.exports = getStyleRule
