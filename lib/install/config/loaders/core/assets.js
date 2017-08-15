const { output } = require('../configuration.js')

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      // Set publicPath with ASSET_HOST env if available so internal assets can use CDN
      publicPath: output.publicPathWithHost,
      name: '[name]-[hash].[ext]'
    }
  }]
}
