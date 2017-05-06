const Url = require('url-parse')
const { env, paths, publicPath } = require('../configuration.js')

// Compute path for internal pack assets if ASSET_HOST is supplied
const computeAssetPath = (host) => {
  if (!host) { return `/${paths.entry}/` }
  const { slashes, href } = new Url(host)
  if (slashes) { return `${href}/${paths.entry}/` }
  if (href) { return `//${href}/${paths.entry}/` }
  return `/${paths.entry}/`
}

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      publicPath: env.NODE_ENV === 'production' ? computeAssetPath(env.ASSET_HOST) : publicPath,
      name: env.NODE_ENV === 'production' ? '[name]-[hash].[ext]' : '[name].[ext]'
    }
  }]
}
