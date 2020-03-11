const { join } = require('path')
const { source_path: sourcePath, static_assets_extensions: fileExtensions, version: version } = require('../config')

module.exports = {
  test: new RegExp(`(${fileExtensions.join('|')})$`, 'i'),
  use: [
    {
      loader: 'file-loader',
      options: {
        name(file) {
          if (file.includes(sourcePath)) {
            return `media/[path][name]-[hash]-${version}.[ext]`
          }
          return `media/[folder]/[name]-[hash:8]-${version}.[ext]`
        },
        context: join(sourcePath)
      }
    }
  ]
}
