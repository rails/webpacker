const Environment = require('../environment')
const { dev_server } = require('../config')
const assetHost = require('../asset_host')
const webpack = require('webpack')

module.exports = class extends Environment {
  constructor() {
    super()

    if (dev_server.hmr) {
      this.plugins.set('HotModuleReplacement', new webpack.HotModuleReplacementPlugin())
      this.plugins.set('NamedModules', new webpack.NamedModulesPlugin())
    }
  }

  toWebpackConfig() {
    const result = super.toWebpackConfig()
    if (dev_server.hmr) {
      result.output.filename = '[name]-[hash].js'
    }
    result.output.pathinfo = true
    result.devtool = 'cheap-eval-source-map'
    result.devServer = {
      host: dev_server.host,
      port: dev_server.port,
      https: dev_server.https,
      hot: dev_server.hmr,
      contentBase: assetHost.path,
      publicPath: assetHost.publicPath,
      clientLogLevel: 'none',
      compress: true,
      historyApiFallback: true,
      headers: {
        'Access-Control-Allow-Origin': '*'
      },
      overlay: true,
      watchOptions: {
        ignored: /node_modules/
      },
      stats: {
        errorDetails: true
      }
    }
    return result
  }
}
