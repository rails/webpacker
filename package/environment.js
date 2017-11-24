/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const {
  basename, dirname, join, relative, resolve
} = require('path')
const { sync } = require('glob')
const extname = require('path-complete-extname')

const webpack = require('webpack')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const ManifestPlugin = require('webpack-manifest-plugin')

const { ConfigList, ConfigObject } = require('./config_types')
const rules = require('./rules')
const config = require('./config')
const assetHost = require('./asset_host')

const getLoaderList = () => {
  const result = new ConfigList()
  Object.keys(rules).forEach(key => result.append(key, rules[key]))
  return result
}

const getPluginList = () => {
  const result = new ConfigList()
  result.append('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))))
  result.append('ExtractText', new ExtractTextPlugin('[name]-[contenthash].css'))
  result.append('Manifest', new ManifestPlugin({ publicPath: assetHost.publicPath, writeToFileEmit: true }))
  return result
}

const getExtensionsGlob = () => {
  const { extensions } = config
  if (!extensions.length) {
    throw new Error('You must configure at least one extension to compile in webpacker.yml')
  }
  return extensions.length === 1 ? `**/${extensions[0]}` : `**/*{${extensions.join(',')}}`
}

const getEntryObject = () => {
  const result = new ConfigObject()
  const glob = getExtensionsGlob()
  const rootPath = join(config.source_path, config.source_entry_path)
  const paths = sync(join(rootPath, glob))
  paths.forEach((path) => {
    const namespace = relative(join(rootPath), dirname(path))
    const name = join(namespace, basename(path, extname(path)))
    result.set(name, resolve(path))
  })
  return result
}

const getModulePaths = () => {
  const result = new ConfigList()
  result.append('source', resolve(config.source_path))
  result.append('node_modules', 'node_modules')
  if (config.resolved_paths) {
    config.resolved_paths.forEach(path => result.append(basename(path), path))
  }
  return result
}

const getBaseConfig = () =>
  new ConfigObject({
    output: {
      filename: '[name]-[chunkhash].js',
      chunkFilename: '[name]-[chunkhash].chunk.js',
      path: assetHost.path,
      publicPath: assetHost.publicPath
    },

    resolve: {
      extensions: config.extensions
    },

    resolveLoader: {
      modules: ['node_modules']
    }
  })

module.exports = class Environment {
  constructor() {
    this.loaders = getLoaderList()
    this.plugins = getPluginList()
    this.config = getBaseConfig()
    this.entry = getEntryObject()
    this.resolvedModules = getModulePaths()
  }

  toWebpackConfig() {
    return this.config.merge({
      entry: this.entry.toObject(),

      module: {
        rules: this.loaders.values()
      },

      plugins: this.plugins.values(),

      resolve: {
        modules: this.resolvedModules.values()
      }
    })
  }
}
