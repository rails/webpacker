/* eslint global-require: 0 */

const { canProcess, moduleExists } = require('./helpers')

const tryPostcss = () =>
  canProcess('postcss-loader', (loaderPath) => ({
    loader: loaderPath,
    options: { sourceMap: true }
  }))

const getStyleRule = (test, preprocessors = []) => {
  if (!moduleExists('mini-css-extract-plugin')) {
    return null
  }

  const MiniCssExtractPlugin = require('mini-css-extract-plugin')
  const use = [
    { loader: MiniCssExtractPlugin.loader },
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

module.exports = getStyleRule
