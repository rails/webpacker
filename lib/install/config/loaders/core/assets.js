const { join } = require('path')
const { output, settings } = require('../configuration.js')

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      context: join(settings.source_path),
      // Set publicPath with ASSET_HOST env if available so internal assets can use CDN
      publicPath: output.publicPathWithHost,
      name: '[path][name]-[hash].[ext]'
    }
  }]
}
