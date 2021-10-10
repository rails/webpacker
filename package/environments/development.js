const { merge } = require('webpack-merge')

const baseConfig = require('./base')
const devServer = require('../dev_server')
const { runningWebpackDevServer } = require('../env')

const { outputPath: contentBase, publicPath } = require('../config')

let devConfig = {
  mode: 'development',
  devtool: 'cheap-module-source-map'
}

if (runningWebpackDevServer) {
  const liveReload = devServer.live_reload !== undefined ? devServer.live_reload : !devServer.hmr

  const devServerConfig = {
    devMiddleware: {
      publicPath
    },
    compress: devServer.compress,
    allowedHosts: devServer.allowed_hosts,
    host: devServer.host,
    port: devServer.port,
    https: devServer.https,
    hot: devServer.hmr,
    liveReload,
    historyApiFallback: { disableDotRule: true },
    headers: devServer.headers,
    static: {
      publicPath: contentBase
    }
  }

  if (devServer.static) {
    devServerConfig.static = { ...devServerConfig.static, ...devServer.static }
  }

  if (devServer.client) {
    devServerConfig.client = devServer.client
  }

  devConfig = merge(devConfig, {
    stats: {
      colors: true,
      entrypoints: false,
      errorDetails: true,
      modules: false,
      moduleTrace: false
    },
    devServer: devServerConfig
  })
}

module.exports = merge(baseConfig, devConfig)
