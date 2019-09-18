const PnpWebpackPlugin = require('pnp-webpack-plugin')

module.exports = {
  test: /\.tsx?(\.erb)?$/,
  use: [
    {
      loader: 'ts-loader',
      options: PnpWebpackPlugin.tsLoaderOptions()
    }
  ]
}
