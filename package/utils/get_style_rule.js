const devServer = require('../dev_server')

const getStyleRule = (test, preprocessors = []) => {
  const use = [
    {
      loader: require.resolve('mini-css-extract-plugin').loader,
      options: {
        // only enable hot in development
        hmr:
          process.env.WEBPACK_DEV_SERVER &&
          process.env.WEBPACK_DEV_SERVER !== 'undefined' &&
          devServer.hmr,
        // if hmr does not work, this is a forceful method.
        reloadAll: true
      }
    },
    {
      loader: require.resolve('css-loader'),
      options: {
        sourceMap: true,
        importLoaders: 2
      }
    },
    {
      loader: require.resolve('postcss-loader'),
      options: { sourceMap: true }
    },
    ...preprocessors
  ]

  return {
    test,
    use
  }
}

module.exports = getStyleRule
