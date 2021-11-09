const { merge } = require('webpack-merge')

const baseConfig = require('./base')
const devServer = require('../dev_server')
const { runningWebpackDevServer } = require('../env')
const inliningCss = require('../inliningCss')
const { moduleExists } = require('../utils/helpers')

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

  let reactHmrPlugin = null
  if (inliningCss && moduleExists('@pmmmwh/react-refresh-webpack-plugin')) {
    // Note, never use this plugin for SSR

    // eslint-disable-next-line global-require
    const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin')
    reactHmrPlugin = new ReactRefreshWebpackPlugin({
        overlay:{
          sockPort: devServer.port
        }
    })
  }

  devConfig = merge(devConfig, {
    stats: {
      colors: true,
      entrypoints: false,
      errorDetails: true,
      modules: false,
      moduleTrace: false
    },
    devServer: devServerConfig,
    plugins: [ reactHmrPlugin ].filter(Boolean)
  })
}

module.exports = merge(baseConfig, devConfig)
