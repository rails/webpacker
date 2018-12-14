const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const { resolve } = require('path')
const devServer = require('../dev_server')
const config = require('../config')

const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))
const isHMR = inDevServer && (devServer && devServer.hmr)

const styleLoader = {
  loader: 'style-loader',
  options: {
    hmr: isHMR,
    sourceMap: true
  }
}

const getStyleRule = (test, modules = false, preprocessors = []) => {
  const use = [
    {
      loader: 'css-loader',
      options: {
        sourceMap: true,
        importLoaders: 2,
        localIdentName: '[name]__[local]___[hash:base64:5]',
        modules
      }
    },
    {
      loader: 'postcss-loader',
      options: {
        config: { path: resolve() },
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
  return Object.assign({}, { test, use, sideEffects: !modules }, options)
}

module.exports = getStyleRule
