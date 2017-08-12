const ExtractTextPlugin = require('extract-text-webpack-plugin')
const path = require('path')
const { env } = require('../configuration.js')

const postcssConfigPath = path.resolve(process.cwd(), '.postcssrc.yml')
const isProduction = env.NODE_ENV === 'production'

const styleLoader = 'style-loader'
const cssLoader = { loader: 'css-loader', options: { minimize: isProduction } }
const postcssLoader = { loader: 'postcss-loader', options: { sourceMap: true, config: { path: postcssConfigPath } } }
const resolveLoader = 'resolve-url-loader'
const sassLoader = { loader: 'sass-loader', options: { sourceMap: true, indentedSyntax: true } }

const extractOptions = {
  fallback: styleLoader,
  use: [cssLoader, postcssLoader, resolveLoader, sassLoader]
}

// For production extract styles to a separate bundle
const extractLoader = {
  test: /\.(scss|sass|css)$/i,
  use: ExtractTextPlugin.extract(extractOptions)
}

// For hot-reloading use regular loaders
const inlineLoader = {
  test: /\.(scss|sass|css)$/i,
  use: [styleLoader].concat(extractOptions.use)
}

module.exports = isProduction ? extractLoader : inlineLoader
