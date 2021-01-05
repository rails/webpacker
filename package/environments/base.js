/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { basename, dirname, join, relative, resolve } = require('path')
const extname = require('path-complete-extname')
const PnpWebpackPlugin = require('pnp-webpack-plugin')
const { sync: globSync } = require('glob')
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin')
const WebpackAssetsManifest = require('webpack-assets-manifest')
const webpack = require('webpack')
const rules = require('../rules')
const config = require('../config')
const { isDevelopment } = require('../env')
const { moduleExists } = require('../utils/helpers')

const getEntryObject = () => {
  const entries = {}
  const rootPath = join(config.source_path, config.source_entry_path)

  globSync(`${rootPath}/**/*.*`).forEach((path) => {
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

const getPlugins = () => {
  const plugins = [
    new webpack.EnvironmentPlugin(process.env),
    new CaseSensitivePathsPlugin(),
    new WebpackAssetsManifest({
      entrypoints: true,
      writeToDisk: true,
      output: 'manifest.json',
      entrypointsUseAssets: true,
      publicPath: true
    })
  ]

  if (moduleExists('css-loader') && moduleExists('mini-css-extract-plugin')) {
    const MiniCssExtractPlugin = require('mini-css-extract-plugin')
    plugins.push(
      new MiniCssExtractPlugin({
        filename: isDevelopment
          ? 'css/[name].css'
          : 'css/[name]-[contenthash:8].css',
        chunkFilename: isDevelopment
          ? 'css/[id].css'
          : 'css/[id]-[contenthash:8].css'
      })
    )
  }

  return plugins
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
    extensions: ['.js', '.jsx', '.mjs', '.ts', '.tsx', '.coffee'],
    modules: getModulePaths(),
    plugins: [PnpWebpackPlugin]
  },

  plugins: getPlugins(),

  resolveLoader: {
    modules: ['node_modules'],
    plugins: [PnpWebpackPlugin.moduleLoader(module)]
  },

  optimization: {
    splitChunks: { chunks: 'all' },

    runtimeChunk: 'single'
  },

  module: {
    strictExportPresence: true,
    rules
  }
}
