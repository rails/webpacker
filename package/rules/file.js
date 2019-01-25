const { static_assets_extensions: fileExtensions } = require('../config')

module.exports = {
  test: new RegExp(`(${fileExtensions.join('|')})$`, 'i'),
  use: [
    {
      loader: 'file-loader',
      options: {
        name: 'media/[name]-[hash:8].[ext]'
      }
    }
  ]
}
