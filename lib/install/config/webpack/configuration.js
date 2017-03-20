// Common configuration for webpacker loaded from config/webpack/paths.yml

const { join, resolve } = require('path')
const { env } = require('process')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const configPath = resolve('config', 'webpack')
const paths = safeLoad(readFileSync(join(configPath, 'paths.yml'), 'utf8'))
const devServer = safeLoad(readFileSync(join(configPath, 'dev_server.yml'), 'utf8'))
const publicPath = env.NODE_ENV !== 'production' && devServer.enabled ?
  `http://${devServer.host}:${devServer.port}/` : `/${paths.entry}/`

module.exports = {
  devServer,
  env,
  paths,
  publicPath
}
