const ExtractTextPlugin = require('extract-text-webpack-plugin')
const path = require('path')
const { dev_server: devServer } = require('../config')

const postcssConfigPath = path.resolve(process.cwd(), '.postcssrc.yml')
const isProduction = process.env.NODE_ENV === 'production'
const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))
const isHMR = inDevServer && (devServer && devServer.hmr)
const extractCSS = !(isHMR) || isProduction

const styleRuleFactory = (test, modules, preprocessors) => {
  const styleLoader = {
    loader: 'style-loader',
    options: {
      hmr: isHMR,
      sourceMap: true
    }
  }

  const extractOptions = {
    fallback: styleLoader,
    use: [
      {
        loader: 'css-loader',
        options: {
          minimize: isProduction, sourceMap: true, importLoaders: 2, modules
        }
      },
      {
        loader: 'postcss-loader',
        options: {
          sourceMap: true, config: { path: postcssConfigPath }
        }
      },
      ...preprocessors
    ]
  }

  const modulesCondition = modules
    ? { include: /\.module\.[a-z]+$/ }
    : { exclude: /\.module\.[a-z]+$/ }

  // For production extract styles to a separate bundle
  const extractCSSLoader = Object.assign(
    {},
    { test, use: ExtractTextPlugin.extract(extractOptions) },
    modulesCondition
  )

  // For hot-reloading use regular loaders
  const inlineCSSLoader = Object.assign(
    {},
    { test, use: [styleLoader].concat(extractOptions.use) },
    modulesCondition
  )

  return extractCSS ? extractCSSLoader : inlineCSSLoader
}

module.exports = styleRuleFactory
