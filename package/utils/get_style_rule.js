const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const config = require('../config')

const styleLoader = {
  loader: require.resolve('style-loader')
}

const getStyleRule = (test, preprocessors = []) => {
  const use = [
    {
      loader: require.resolve('css-loader'),
      options: {
        sourceMap: true,
        importLoaders: 2
      }
    },
    {
      loader: require.resolve('postcss-loader'),
      options: {
        sourceMap: true
      }
    },
    ...preprocessors
  ]

  if (config.extract_css) {
    use.unshift(MiniCssExtractPlugin.loader)
  } else {
    use.unshift(styleLoader)
  }

  return {
    test,
    use
  }
}

module.exports = getStyleRule
