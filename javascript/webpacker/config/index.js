// Common configuration for webpacker loaded from config/webpack/paths.yml

const { env } = require('process')
const { getIfUtils, propIf } = require('webpack-config-utils')
const { join, resolve } = require('path')
const { readFileSync } = require('fs')
const { safeLoad } = require('js-yaml')
const computeAssetUrl = require('../utils/computer-asset-url')

// Define webpack configuration file path
const appConfigPath = resolve(process.cwd(), 'config', 'webpack')

// Setup environment utils
const { ifProduction, ifDevelopment, ifTest } = getIfUtils(process.env.NODE_ENV)

// Load configuration from .yml files
const devServer = safeLoad(readFileSync(join(appConfigPath, 'development.server.yml'), 'utf8'))[env.NODE_ENV]
const paths = safeLoad(readFileSync(join(appConfigPath, 'paths.yml'), 'utf8'))[env.NODE_ENV]
const settings = safeLoad(readFileSync(join(appConfigPath, 'settings.yml'), 'utf8'))

// Compute public path based on environment and CDN option
const devServerUrl = `${devServer.protocol}://${devServer.host}:${devServer.port}/`
const ifHasCDN = env.ASSET_HOST !== undefined && ifProduction()
const publicUrl = propIf(ifHasCDN, `${computeAssetUrl(env.ASSET_HOST)}${paths.entry}/`, `/${paths.entry}/`)
const publicPath = propIf(ifDevelopment(), devServerUrl, publicUrl)

// Define path helpers
const manifestPath = resolve(paths.output, paths.entry, paths.manifest)
const outputPath = resolve(paths.output, paths.entry)

// Export common configuration
module.exports = {
  appConfigPath,
  devServer,
  env,
  ifDevelopment,
  ifProduction,
  ifTest,
  manifestPath,
  outputPath,
  paths,
  publicPath,
  publicUrl,
  settings
}
