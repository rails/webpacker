const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const config = require('../config')

const styleLoader = {
  loader: 'style-loader'
}

const getStyleRule = (test, modules = false, preprocessors = []) => {
  const use = [
    {
      loader: 'css-loader',
      options: {
        sourceMap: true,
        importLoaders: 2,
        modules: modules ? {
          localIdentName: '[name]__[local]___[hash:base64:5]'
        } : false
      }
    },
    {
      loader: 'postcss-loader',
      options: {
        sourceMap: true
      }
    },
    ...preprocessors
  ]

  const options = modules ? { include: /\.module\.[a-z]+$/ } : { exclude: /\.module\.[a-z]+$/ }

  if (config.extract_css) {
    use.unshift(MiniCssExtractPlugin.loader)
  } else {
    use.unshift(styleLoader)
  }

  // sideEffects - See https://github.com/webpack/webpack/issues/6571
  return {
    test, use, sideEffects: !modules, ...options
  }
}

module.exports = getStyleRule
