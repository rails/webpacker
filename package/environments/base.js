/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { basename, dirname, join, relative, resolve } = require('path')
const extname = require('path-complete-extname')
const PnpWebpackPlugin = require('pnp-webpack-plugin')
const { sync } = require('glob')
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin')
const WebpackAssetsManifest = require('webpack-assets-manifest')
const webpack = require('webpack')
const rules = require('../rules')
const config = require('../config')
const { isDevelopment } = require('../env')

const getEntryObject = () => {
  const entries = {}
  const rootPath = join(config.source_path, config.source_entry_path)

  sync(`${rootPath}/**/*.*`).forEach((path) => {
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
    PnpWebpackPlugin,
    new CaseSensitivePathsPlugin(),
    new WebpackAssetsManifest({
      entrypoints: true,
      writeToDisk: true,
      output: 'manifest.json',
      entrypointsUseAssets: true,
      publicPath: true
    })
  ]

  try {
    if (require.resolve('css-loader')) {
      const MiniCssExtractPlugin = require('mini-css-extract-plugin')
      plugins.push(
        new MiniCssExtractPlugin({
          filename: isDevelopment ? '[name].css' : '[name].[contenthash:8].css',
          chunkFilename: isDevelopment ? '[id].css' : '[id].[contenthash:8].css'
        })
      )
    }
  } catch (e) {
    /* Work out what to print here */
  }

  return plugins
}

module.exports = {
  mode: 'production',
  output: {
    filename: 'js/[name]-[contenthash].js',
    chunkFilename: 'js/[name]-[contenthash].chunk.js',
    hotUpdateChunkFilename: 'js/[id]-[hash].hot-update.js',
    assetModuleFilename: 'static/[hash][ext][query]',
    path: config.outputPath,
    publicPath: config.publicPath
  },
  entry: getEntryObject(),
  resolve: {
    extensions: ['.js', '.mjs', '.ts'],
    modules: getModulePaths()
  },

  plugins: getPlugins(),

  resolveLoader: {
    modules: ['node_modules'],
    plugins: [PnpWebpackPlugin.moduleLoader(module)]
  },

  optimization: {
    splitChunks: { chunks: 'all' },

    runtimeChunk: { name: (entrypoint) => `runtime-${entrypoint.name}` }
  },

  module: {
    strictExportPresence: true,
    rules
  }
}
