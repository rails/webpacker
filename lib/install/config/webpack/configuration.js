// Common configuration for webpacker loaded from config/webpack/configuration.yml

const { join, resolve } = require('path')
const { env } = require('process')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const configPath = resolve('config', 'webpack')
const loadersDir = join(__dirname, 'loaders')
const { devServer, paths } = safeLoad(readFileSync(join(configPath, 'configuration.yml'), 'utf8'))[env.NODE_ENV]

// Compute public path based on environment and ASSET_HOST in production
const ifHasCDN = env.ASSET_HOST !== undefined && env.NODE_ENV === 'production'
const devServerUrl = `http://${devServer.host}:${devServer.port}/${paths.entry}/`
const publicUrl = ifHasCDN ? `${env.ASSET_HOST}/${paths.entry}/` : `/${paths.entry}/`
const publicPath = env.NODE_ENV !== 'production' && devServer.enabled ? devServerUrl : publicUrl

module.exports = {
  devServer,
  env,
  paths,
  loadersDir,
  publicUrl,
  publicPath
}
