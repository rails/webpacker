// Common configuration for webpacker loaded from config/webpack/paths.yml

const { join, resolve } = require('path')
const { env } = require('process')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const configPath = resolve('config', 'webpack')
const loadersDir = join(__dirname, 'loaders')
const paths = safeLoad(readFileSync(join(configPath, 'paths.yml'), 'utf8'))[env.NODE_ENV]
const devServer = safeLoad(readFileSync(join(configPath, 'development.server.yml'), 'utf8'))[env.NODE_ENV]

function removeOuterSlashes(string) {
  return string.replace(/^\/*/, '').replace(/\/*$/, '')
}

function formatPublicPath(host = '', path = '') {
  host = removeOuterSlashes(host)
  path = removeOuterSlashes(path)
  if (host && !/^http/i.test(host)) {
    host = `//${host}`
  }
  return `${host}/${path}/`
}

const output = {
  path: resolve('public', paths.output),
  publicPath: formatPublicPath(env.ASSET_HOST, paths.output)
}

module.exports = {
  devServer,
  env,
  paths,
  loadersDir,
  output,
  formatPublicPath
}
