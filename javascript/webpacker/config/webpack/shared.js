// Note: You must restart bin/webpack-watcher for changes to take effect
/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { basename, dirname, join, relative, resolve } = require('path')
const extname = require('path-complete-extname')
const ManifestPlugin = require('webpack-manifest-plugin')
const { removeEmpty } = require('webpack-config-utils')
const { sync } = require('glob')
const webpack = require('webpack')
const { appConfigPath, env, paths, publicPath, outputPath } = require('../index')

const extensionGlob = `**/*{${paths.extensions.join(',')}}*`
const packPaths = sync(join(paths.source, paths.entry, extensionGlob))

// Merge app loaders with base loaders
const appLoaders = sync(join(appConfigPath, 'loaders', '*.js'))
const baseLoaders = sync(join(__dirname, '..', 'loaders', '*.js'))

module.exports = {
  entry: packPaths.reduce(
    (map, entry) => {
      const localMap = map
      const namespace = relative(join(paths.source, paths.entry), dirname(entry))
      localMap[join(namespace, basename(entry, extname(entry)))] = resolve(entry)
      return localMap
    }, {}
  ),

  output: {
    filename: '[name].js',
    path: outputPath,
    publicPath
  },

  module: {
    // Concat app defined loaders to base loaders
    rules: baseLoaders.concat(appLoaders).map(loader => require(loader))
  },

  plugins: [
    new webpack.EnvironmentPlugin(removeEmpty(env)),
    new ManifestPlugin({ fileName: paths.manifest, publicPath, writeToFileEmit: true })
  ],

  resolve: {
    extensions: paths.extensions,
    modules: [resolve(paths.source), 'node_modules']
  },

  resolveLoader: {
    modules: ['node_modules']
  },

  node: {
    fs: 'empty',
    net: 'empty',
    tls: 'empty',
    global: true,
    process: true,
    Buffer: true,
    setImmediate: true
  }
}
