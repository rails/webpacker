const config = require('../config')
const assetHost = require('../asset_host')
const { join } = require('path')

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[path][name]-[hash].[ext]',
      context: join(config.source_path),
      publicPath: assetHost.publicPathWithHost
    }
  }]
}
