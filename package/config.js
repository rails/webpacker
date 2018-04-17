const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')
const deepMerge = require('./utils/deep_merge')
const { isArray } = require('./utils/helpers')
const { railsEnv } = require('./env')

const defaultConfigPath = require.resolve('../lib/install/config/webpacker.yml')
const configPath = resolve('config', 'webpacker.yml')

const getDefaultConfig = () => {
  const defaultConfig = safeLoad(readFileSync(defaultConfigPath), 'utf8')
  return defaultConfig[railsEnv] || defaultConfig.production
}

const defaults = getDefaultConfig()
const app = safeLoad(readFileSync(configPath), 'utf8')[railsEnv]

if (isArray(app.extensions) && app.extensions.length) delete defaults.extensions

const config = deepMerge(defaults, app)
config.outputPath = resolve('public', config.public_output_path)

let publicPath = `/${config.public_output_path}/`
// Add prefix to publicPath.
if (process.env.RAILS_RELATIVE_URL_ROOT) {
  publicPath = `/${process.env.RAILS_RELATIVE_URL_ROOT}${publicPath}`
}

// Remove extra slashes.
config.publicPath = publicPath.replace(/(^\/|[^:]\/)\/+/g, '$1')

module.exports = config
