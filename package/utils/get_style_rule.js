const { loaderCheckingExists, packagePath } = require('./helpers')


const tryPostcss = () => loaderCheckingExists('postcss-loader',
    (loaderPath) => ({
          loader: loaderPath,
          options: { sourceMap: true }
        }
    ))

const getStyleRule = (test, preprocessors = []) => {
  if (!packagePath('mini-css-extract-plugin')) {
    return null
  }

  /* eslint global-require: 0 */
  const MiniCssExtractPlugin= require('mini-css-extract-plugin')
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
