const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')
const deepMerge = require('./utils/deep_merge')
const { isArray } = require('./utils/helpers')
const env = require('./env')

const defaultConfigPath = require.resolve('../lib/install/config/webpacker.yml')
const configPath = resolve('config', 'webpacker.yml')

const getConfig = () => {
  const defaults = safeLoad(readFileSync(defaultConfigPath), 'utf8')[env]
  const app = safeLoad(readFileSync(configPath), 'utf8')[env]

  if (isArray(app.extensions) && app.extensions.length) {
    delete defaults.extensions
  }

  const config = deepMerge(defaults, app)

  config.outputPath = resolve('public', config.public_output_path)
  config.publicPath = `/${config.public_output_path}/`.replace(/([^:]\/)\/+/g, '$1')

  return config
}

module.exports = getConfig()
