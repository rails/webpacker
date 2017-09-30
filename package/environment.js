/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { basename, dirname, join, relative, resolve } = require('path')
const { sync } = require('glob')
const extname = require('path-complete-extname')

const webpack = require('webpack')
const merge = require('webpack-merge')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const ManifestPlugin = require('webpack-manifest-plugin')

const rules = require('./rules')
const assetHost = require('./asset_host')
const {
  source_path: sourcePath,
  resolved_paths: resolvedPaths,
  source_entry_path: sourceEntryPath,
  extensions
} = require('./config')

const getBaseLoaders = () =>
  Object.values(rules).map(rule => rule)

const getBaseResolvedModules = () => {
  const result = []
  result.push(resolve(sourcePath))
  result.push('node_modules')
  if (resolvedPaths) {
    resolvedPaths.forEach(path => result.push(path))
  }
  return result
}

const getExtensionsGlob = () => {
  if (!extensions.length) {
    throw new Error('You must configure at least one extension to compile in webpacker.yml')
  }
  return extensions.length === 1 ? `**/${extensions[0]}` : `**/*{${extensions.join(',')}}`
}

const getEntryObject = () => {
  const result = {}
  const glob = getExtensionsGlob()
  const entryPath = join(sourcePath, sourceEntryPath)
  const entryPaths = sync(join(entryPath, glob))
  entryPaths.forEach((path) => {
    const namespace = relative(join(entryPath), dirname(path))
    const name = join(namespace, basename(path, extname(path)))
    result[name] = resolve(path)
  })
  return result
}

const makeArray = obj => (Array.isArray(obj) ? obj : [obj])

module.exports = class Environment {
  constructor() {
    this.mergeOptions = {
      entry: 'append',
      'module.rules': 'append',
      plugins: 'append'
    }

    this.config = {
      entry: getEntryObject(),

      output: {
        filename: '[name]-[chunkhash].js',
        chunkFilename: '[name]-[chunkhash].chunk.js',
        path: assetHost.path,
        publicPath: assetHost.publicPath
      },

      module: {
        rules: getBaseLoaders()
      },

      plugins: [
        new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))),
        new ExtractTextPlugin('[name]-[contenthash].css'),
        new ManifestPlugin({ publicPath: assetHost.publicPath, writeToFileEmit: true })
      ],

      resolve: {
        extensions,
        modules: getBaseResolvedModules()
      },

      resolveLoader: {
        modules: ['node_modules']
      }
    }
  }

  addEntry(entry) {
    this.mergeConfig({
      entry: makeArray(entry)
    })
  }

  addRule(rule) {
    this.mergeConfig({
      module: {
        rules: makeArray(rule)
      }
    })
  }

  addPlugin(plugin) {
    this.mergeConfig({
      plugins: makeArray(plugin)
    })
  }

  addResolvedModule(module) {
    this.mergeConfig({
      resolve: {
        modules: makeArray(module)
      }
    })
  }

  addLoader(ruleName, loader) {
    makeArray(ruleName).forEach(rule => this.updateRule(rule, { use: makeArray(loader) }))
  }

  updateRule(name, options = {}) {
    const rule = rules[name]
    if (!rule) throw new Error(`Rule ${name} not found in ${JSON.stringify(rules, null, 2)}`)
    this.addRule(merge.smart(rule, options))
  }

  mergeConfig(config) {
    this.config = merge.smartStrategy(this.mergeOptions)(this.config, config)
    return this.config
  }
}
