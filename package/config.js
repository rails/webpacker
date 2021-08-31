const { resolve } = require('path')
const { load } = require('js-yaml')
const { readFileSync } = require('fs')
const { merge } = require('webpack-merge')
const { ensureTrailingSlash } = require('./utils/helpers')
const { railsEnv } = require('./env')
const configPath = require('./configPath')

const defaultConfigPath = require.resolve('../lib/install/config/webpacker.yml')

const getDefaultConfig = () => {
  const defaultConfig = load(readFileSync(defaultConfigPath), 'utf8')
  return defaultConfig[railsEnv] || defaultConfig.production
}

const defaults = getDefaultConfig()
const app = load(readFileSync(configPath), 'utf8')[railsEnv]

const config = merge(defaults, app)
config.outputPath = resolve(config.public_root_path, config.public_output_path)

// Ensure that the publicPath includes our asset host so dynamic imports
// (code-splitting chunks and static assets) load from the CDN instead of a relative path.
const getPublicPath = () => {
  const rootUrl = ensureTrailingSlash(process.env.WEBPACKER_ASSET_HOST || '/')
  return `${rootUrl}${config.public_output_path}/`
}

config.publicPath = getPublicPath()
config.publicPathWithoutCDN = `/${config.public_output_path}/`

module.exports = config
