const MiniCssExtractPlugin = require('mini-css-extract-plugin')

const getStyleRule = (test, preprocessors = []) => {
  const use = [
    { loader: MiniCssExtractPlugin.loader },
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
