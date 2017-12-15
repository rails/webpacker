const { join } = require('path')
const { source_path } = require('../config')

module.exports = {
  exclude: /\.(js|jsx|coffee|ts|tsx|vue|elm|scss|sass|css|html|json)?(\.erb)?$/,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[path][name]-[hash].[ext]',
      context: join(source_path)
    }
  }]
}
