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
  if (devServer.hmr) {
    devConfig = merge(devConfig, {
      output: { filename: '[name]-[hash].js' }
    })
  }

  let staticConfig = { publicPath: contentBase }
  if (devServer.static) {
    staticConfig = { ...staticConfig, ...devServer.static }
  }

  devConfig = merge(devConfig, {
    stats: {
      colors: true,
      entrypoints: false,
      errorDetails: true,
      modules: false,
      moduleTrace: false
    },
    devServer: {
      client: {
        overlay: devServer.overlay
      },
      devMiddleware: {
        publicPath
      },
      compress: devServer.compress,
      allowedHosts: devServer.allowed_hosts,
      host: devServer.host,
      port: devServer.port,
      https: devServer.https,
      hot: devServer.hmr,
      historyApiFallback: { disableDotRule: true },
      headers: devServer.headers,
      static: staticConfig
    }
  })
}

module.exports = merge(baseConfig, devConfig)
