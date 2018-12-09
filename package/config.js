const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')
const deepMerge = require('./utils/deep_merge')
const { isArray, removeTrailingSlash } = require('./utils/helpers')
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

// Ensure that the publicPath includes our asset host so dynamic imports
// (code-splitting chunks and static assets) load from the CDN instead of a relative path.
const getPublicPath = () => {
  const rootUrl = removeTrailingSlash(process.env.WEBPACKER_ASSET_HOST || '')
  let packPath = `/${config.public_output_path}/`

  // Add relative root prefix to pack path.
  if (process.env.RAILS_RELATIVE_URL_ROOT) {
    packPath = `/${process.env.RAILS_RELATIVE_URL_ROOT}${packPath}`
  }

  return rootUrl + packPath
}

config.publicPath = getPublicPath()

module.exports = config
