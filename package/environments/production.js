const webpack = require('webpack')
const CompressionPlugin = require('compression-webpack-plugin')
const Environment = require('../environment')

module.exports = class extends Environment {
  constructor() {
    super()

    this.addPlugin(new webpack.optimize.ModuleConcatenationPlugin())

    this.addPlugin(new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,
      compress: {
        warnings: false
      },
      output: {
        comments: false
      }
    }))

    this.addPlugin(new CompressionPlugin({
      asset: '[path].gz[query]',
      algorithm: 'gzip',
      test: /\.(js|css|html|json|ico|svg|eot|otf|ttf)$/
    }))

    this.config.devtool = 'nosources-source-map'
    this.config.stats = 'normal'
  }
}
