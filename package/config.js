const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')
const deepMerge = require('./utils/deep_merge')

const defaultFilePath = require.resolve('../lib/install/config/webpacker.yml')
const filePath = resolve('config', 'webpacker.yml')

const environment = process.env.NODE_ENV || 'development'
const defaultConfig = safeLoad(readFileSync(defaultFilePath), 'utf8')[environment]
const appConfig = safeLoad(readFileSync(filePath), 'utf8')[environment]
const config = deepMerge(defaultConfig, appConfig)

const isBoolean = str => /^true/.test(str) || /^false/.test(str)

const fetch = key =>
  (isBoolean(process.env[key]) ? JSON.parse(process.env[key]) : process.env[key])

const devServer = (key) => {
  const envValue = fetch(`WEBPACKER_DEV_SERVER_${key.toUpperCase().replace(/_/g, '')}`)
  if (typeof envValue === 'undefined' || envValue === null) return config.dev_server[key]
  return envValue
}

if (config.dev_server) {
  Object.keys(config.dev_server).forEach((key) => {
    config.dev_server[key] = devServer(key)
  })
}

config.outputPath = resolve('public', config.public_output_path)
config.publicPath = `/${config.public_output_path}/`.replace(/([^:]\/)\/+/g, '$1')

module.exports = config
