const Url = require('url-parse')
const { env, paths, publicPath } = require('../configuration.js')

// Make sure host has slashes
const ensureSlashes = ({ host, slashes }) => {
  if (slashes) { return `${host}/${paths.entry}/` }
  return `//${host}/${paths.entry}/`
}

// Compute path for internal pack assets if ASSET_HOST is supplied
const computeAssetPath = (host) => {
  if (!host) { return `/${paths.entry}/` }
  return ensureSlashes(new Url(host))
}

// Get asset options based on NODE_ENV
const assetOptions = (nodeENV) => {
  if (nodeENV === 'production') {
    return { publicPath: computeAssetPath(env.ASSET_HOST), name: '[name]-[hash].[ext]' }
  }
  return { publicPath, name: '[name].[ext]' }
}

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: assetOptions(env.NODE_ENV)
  }]
}
