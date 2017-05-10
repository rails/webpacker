/* eslint no-else-return: 0 */

const Url = require('url-parse')
const { env, paths, publicPath } = require('../configuration.js')

// Make sure host has slashes
const ensureSlashes = ({ href, slashes }) => {
  if (slashes) {
    return `${href}/${paths.entry}/`
  } else {
    return `//${href}/${paths.entry}/`
  }
}

// Compute path for internal pack assets if ASSET_HOST is supplied
const computeAssetPath = (host) => {
  if (!host) {
    return `/${paths.entry}/`
  } else {
    return ensureSlashes(new Url(host))
  }
}

// Get asset options based on NODE_ENV
const assetOptions = (nodeENV) => {
  if (nodeENV === 'production') {
    return { publicPath: computeAssetPath(env.ASSET_HOST), name: '[name]-[hash].[ext]' }
  } else {
    return { publicPath, name: '[name].[ext]' }
  }
}

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: assetOptions(env.NODE_ENV)
  }]
}
