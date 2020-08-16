const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = new MiniCssExtractPlugin({
  filename: 'css/[name]-[contenthash:8].css',
  chunkFilename: 'css/[name]-[contenthash:8].chunk.css'
})
