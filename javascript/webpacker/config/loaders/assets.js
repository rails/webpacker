const { ifProduction, publicPath } = require('../index')

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      publicPath,
      name: ifProduction() ? '[name]-[hash].[ext]' : '[name].[ext]'
    }
  }]
}
