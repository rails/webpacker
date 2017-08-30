const ExtractTextPlugin = require('extract-text-webpack-plugin')
const path = require('path')
const config = require('../config')

const postcssConfigPath = path.resolve(process.cwd(), '.postcssrc.yml')
const isProduction = process.env.NODE_ENV === 'production'
const extractCSS = !(config.dev_server && config.dev_server.hmr)

const extractOptions = {
  fallback: 'style-loader',
  use: [
    { loader: 'css-loader', options: { minimize: isProduction } },
    { loader: 'postcss-loader', options: { sourceMap: true, config: { path: postcssConfigPath } } },
    'resolve-url-loader',
    { loader: 'sass-loader', options: { sourceMap: true } }
  ]
}

// For production extract styles to a separate bundle
const extractCSSLoader = {
  test: /\.(scss|sass|css)$/i,
  use: ExtractTextPlugin.extract(extractOptions)
}

// For hot-reloading use regular loaders
const inlineCSSLoader = {
  test: /\.(scss|sass|css)$/i,
  use: ['style-loader'].concat(extractOptions.use)
}

module.exports = isProduction || extractCSS ? extractCSSLoader : inlineCSSLoader
