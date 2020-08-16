/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { basename, dirname, join, relative, resolve } = require('path')
const extname = require('path-complete-extname')
const PnpWebpackPlugin = require('pnp-webpack-plugin')
const { readdirSync } = require('fs')
const rules = require('../rules')
const plugins = require('../plugins')
const config = require('../config')

const getRulesList = () => {
  const list = []
  Object.keys(rules).forEach((key) => list.push(rules[key]))
  return list
}

const getEntryObject = () => {
  const entries = {}

  const rootPath = join(config.source_path, config.source_entry_path)
  const paths = readdirSync(rootPath)

  paths.forEach((path) => {
    const namespace = relative(join(rootPath), dirname(path))
    const name = join(namespace, basename(path, extname(path)))
    let assetPaths = resolve(path)

    // Allows for multiple filetypes per entry (https://webpack.js.org/guides/entry-advanced/)
    // Transforms the config object value to an array with all values under the same name
    let previousPaths = entries[name]
    if (previousPaths) {
      previousPaths = Array.isArray(previousPaths)
        ? previousPaths
        : [previousPaths]
      previousPaths.push(assetPaths)
      assetPaths = previousPaths
    }

    entries[name] = assetPaths
  })

  return entries
}

const getModulePaths = () => {
  const result = [resolve(config.source_path)]

  if (config.additional_paths) {
    config.additional_paths.forEach((path) => result.push(resolve(path)))
  }
  result.push('node_modules')

  return result
}

module.exports = {
  mode: 'production',
  output: {
    filename: 'js/[name]-[contenthash].js',
    chunkFilename: 'js/[name]-[contenthash].chunk.js',
    hotUpdateChunkFilename: 'js/[id]-[hash].hot-update.js',
    path: config.outputPath,
    publicPath: config.publicPath
  },
  entry: getEntryObject(),
  resolve: {
    extensions: config.extensions,
    modules: getModulePaths()
  },

  plugins: plugins.shared,

  optimization: {
    splitChunks: {
      chunks: 'all',
      name: true
    },
    runtimeChunk: 'single'
  },
  resolveLoader: {
    modules: ['node_modules'],
    plugins: [PnpWebpackPlugin.moduleLoader(module)]
  },

  module: {
    strictExportPresence: true,
    rules: getRulesList()
  },

  node: {
    dgram: 'empty',
    fs: 'empty',
    net: 'empty',
    tls: 'empty',
    child_process: 'empty'
  }
}
