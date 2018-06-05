/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const {
  basename, dirname, join, relative, resolve
} = require('path')
const { sync } = require('glob')
const extname = require('path-complete-extname')

const webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const WebpackAssetsManifest = require('webpack-assets-manifest')
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

const { ConfigList, ConfigObject } = require('../config_types')
const rules = require('../rules')
const config = require('../config')

const getLoaderList = () => {
  const result = new ConfigList()
  Object.keys(rules).forEach(key => result.append(key, rules[key]))
  return result
};

const getPluginList = () => {
  const result = new ConfigList()
  result.append(
    'Environment',
    new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env)))
  )
  result.append('CaseSensitivePaths', new CaseSensitivePathsPlugin())
  result.append(
    'ExtractText',
    new MiniCssExtractPlugin({
      filename: '[name]-[contenthash:8].css',
      chunkFilename: '[name]-[contenthash:8].chunk.css'
    })
  )
  result.append(
    'Manifest',
    new WebpackAssetsManifest({
      writeToDisk: true,
      publicPath: true
    })
  )
  if (config.optimize_css) {
    result.append('OptimizeCSSAssets', new OptimizeCSSAssetsPlugin())
  }
  if (config.gzip) {
    result.append(
      'Compression',
      new CompressionPlugin({
        asset: '[path].gz[query]',
        algorithm: 'gzip',
        test: /\.(js|css|html|json|ico|svg|eot|otf|ttf)$/
      })
    )
  }
  return result
}

const getExtensionsGlob = () => {
  const { extensions } = config
  return extensions.length === 1 ? `**/*${extensions[0]}` : `**/*{${extensions.join(',')}}`
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
  if (config.resolved_paths) {
    config.resolved_paths.forEach(path => result.append(path, resolve(path)))
  }
  result.append('node_modules', 'node_modules')
  return result
}

const buildUglifier = () => {
  const options = {
    parallel: true,
    cache: true,
    sourceMap: true,
    uglifyOptions: {
      compress: {
        ecma: 5,
        warnings: false,
        comparisons: false
      },
      output: {
        ecma: 5,
        comments: false,
        ascii_only: true
      },
      parse: {
        // Let uglify-js parse ecma 8 code but always output
        // ES5 compliant code for older browsers
        ecma: 8
      },
      safari10: true
    }
  }
  if (config.uglify === 'fast') {
    options.uglifyOptions.compress = false
  }
  return new UglifyJsPlugin(options)
}

const getBaseConfig = () => {
  const options = {
    mode: 'production',
    output: {
      filename: '[name]-[chunkhash].js',
      chunkFilename: '[name]-[chunkhash].chunk.js',
      hotUpdateChunkFilename: '[id]-[hash].hot-update.js',
      path: config.outputPath,
      publicPath: config.publicPath
    },

    resolve: {
      extensions: config.extensions
    },

    resolveLoader: {
      modules: ['node_modules']
    },

    node: {
      dgram: 'empty',
      fs: 'empty',
      net: 'empty',
      tls: 'empty',
      child_process: 'empty'
    }
  }
  // eslint-disable-next-line no-prototype-builtins
  if (config.hasOwnProperty('devtool')) { options.devtool = config.devtool }
  if (config.uglify) { options.optimization = { minimizer: [buildUglifier] } }

  return new ConfigObject(options)
}

module.exports = class Base {
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
        strictExportPresence: true,
        rules: this.loaders.values()
      },

      plugins: this.plugins.values(),

      resolve: {
        modules: this.resolvedModules.values()
      }
    })
  }
}
