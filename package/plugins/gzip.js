const CompressionPlugin = require('compression-webpack-plugin')

module.exports = new CompressionPlugin({
  filename: '[path].gz[query]',
  algorithm: 'gzip',
  test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/
})
