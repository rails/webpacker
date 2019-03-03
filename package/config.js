const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')
const deepMerge = require('./utils/deep_merge')
const { isArray, ensureTrailingSlash } = require('./utils/helpers')
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
if (isArray(app.static_assets_extensions) && app.static_assets_extensions.length) {
  delete defaults.static_assets_extensions
}

const config = deepMerge(defaults, app)
config.outputPath = resolve(config.public_root_path, config.public_output_path)

// Ensure that the publicPath includes our asset host so dynamic imports
// (code-splitting chunks and static assets) load from the CDN instead of a relative path.
const getPublicPath = () => {
  const rootUrl = process.env.WEBPACKER_ASSET_HOST || '/'
  let packPath = `${config.public_output_path}/`
  // Add relative root prefix to pack path.
  if (process.env.RAILS_RELATIVE_URL_ROOT) {
    let relativeRoot = process.env.RAILS_RELATIVE_URL_ROOT
    relativeRoot = relativeRoot.startsWith('/') ? relativeRoot.substr(1) : relativeRoot
    packPath = `${ensureTrailingSlash(relativeRoot)}${packPath}`
  }

  return ensureTrailingSlash(rootUrl) + packPath
}

config.publicPath = getPublicPath()
config.publicPathWithoutCDN = `/${config.public_output_path}/`

module.exports = config
