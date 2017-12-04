const assetHost = require('../asset_host')

module.exports = {
  test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
  use: [{
    loader: 'url-loader',
    options: {
      limit: 10000,
      name: '[name]-[hash].[ext]',
      publicPath: assetHost.publicPathWithHost
    }
  }]
}
