const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const path = require('path')
const { existsSync } = require('fs')
const devServer = require('../dev_server')
const { nodeEnv } = require('../env')

const isProduction = nodeEnv === 'production'
const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))
const isHMR = inDevServer && (devServer && devServer.hmr)
const extractCSS = !isHMR || isProduction

let postcssConfigPath

if (existsSync(`${process.cwd()}/.postcssrc.yml`)) {
  postcssConfigPath = path.resolve(process.cwd(), '.postcssrc.yml')
} else {
  postcssConfigPath = require.resolve('../../lib/install/config/.postcssrc.yml')
}

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
        minimize: isProduction,
        sourceMap: true,
        importLoaders: 2,
        modules
      }
    },
    {
      loader: 'postcss-loader',
      options: {
        sourceMap: true,
        config: { path: postcssConfigPath }
      }
    },
    ...preprocessors
  ]

  const options = modules ? { include: /\.module\.[a-z]+$/ } : { exclude: /\.module\.[a-z]+$/ }

  if (extractCSS) {
    use.unshift(MiniCssExtractPlugin.loader)
  } else {
    use.unshift(styleLoader)
  }

  return Object.assign({}, { test, use }, options)
}

module.exports = getStyleRule
