// Common configuration for webpacker loaded from config/webpack/paths.yml

const { join, resolve } = require('path')
const { env } = require('process')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const configPath = resolve('config', 'webpack')
const loadersDir = join(__dirname, 'loaders')
const paths = safeLoad(readFileSync(join(configPath, 'paths.yml'), 'utf8'))[env.NODE_ENV]
const devServer = safeLoad(readFileSync(join(configPath, 'development.server.yml'), 'utf8'))[env.NODE_ENV]

// Compute public path based on environment
const publicPath = env.NODE_ENV !== 'production' && devServer.enabled ?
  `//${devServer.host}:${devServer.port}/${paths.entry}/` : `/${paths.entry}/`

module.exports = {
  devServer,
  env,
  paths,
  loadersDir,
  publicPath
}
