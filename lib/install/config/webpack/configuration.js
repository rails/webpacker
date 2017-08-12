// Common configuration for webpacker loaded from config/webpacker.yml

const { join, resolve } = require('path')
const { env } = require('process')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const configPath = resolve('config', 'webpacker.yml')
const loadersDir = join(__dirname, 'loaders')
const settings = safeLoad(readFileSync(configPath), 'utf8')[env.NODE_ENV]

function removeOuterSlashes(string) {
  return string.replace(/^\/*/, '').replace(/\/*$/, '')
}

function formatPublicPath(host = '', path = '') {
  let formattedHost = removeOuterSlashes(host)
  if (formattedHost && !/^http/i.test(formattedHost)) {
    formattedHost = `//${formattedHost}`
  }
  const formattedPath = removeOuterSlashes(path)
  return `${formattedHost}/${formattedPath}/`
}

const output = {
  path: resolve('public', settings.public_output_path),
  publicPath: `/${settings.public_output_path}/`.replace(/([^:]\/)\/+/g, '$1'),
  publicPathWithHost: formatPublicPath(env.ASSET_HOST, settings.public_output_path)
}

let resolvedModules = [
  resolve(settings.source_path),
  'node_modules'
]

if (settings.resolved_paths && Array.isArray(settings.resolved_paths)) {
  resolvedModules = resolvedModules.concat(settings.resolved_paths)
}

module.exports = {
  settings,
  resolvedModules,
  env,
  loadersDir,
  output
}
