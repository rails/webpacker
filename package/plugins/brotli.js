const CompressionPlugin = require('compression-webpack-plugin')

module.exports = new CompressionPlugin({
  filename: '[path].br[query]',
  algorithm: 'brotliCompress',
  test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
})
