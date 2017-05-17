// Note: You must restart bin/webpack-dev-server for changes to take effect

const { resolve } = require('path')
const merge = require('webpack-merge')
const ManifestPlugin = require('webpack-manifest-plugin')
const devConfig = require('./development.js')
const { devServer, paths, output, formatPublicPath } = require('./configuration.js')

const { host, port } = devServer
const contentBase = output.path
const publicPath = formatPublicPath(`http://${host}:${port}`, paths.output)

// Remove ManifestPlugin so we can replace it with a new one
devConfig.plugins = devConfig.plugins.filter(plugin => plugin.constructor.name !== 'ManifestPlugin')

module.exports = merge(devConfig, {
  output: {
    publicPath
  },

  devServer: {
    host,
    port,
    contentBase,
    publicPath,
    compress: true,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true
  },

  plugins: [
    new ManifestPlugin({ fileName: paths.manifest, publicPath, writeToFileEmit: true })
  ]
})
