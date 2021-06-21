const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const NODE_ENVIRONMENTS = ['development', 'production', 'test']
const DEFAULT = 'production'
const configPath = require('./configPath')

const railsEnv = process.env.RAILS_ENV
const rawNodeEnv = process.env.NODE_ENV
const nodeEnv
  = rawNodeEnv && NODE_ENVIRONMENTS.includes(rawNodeEnv) ? rawNodeEnv : DEFAULT
const isProduction = nodeEnv === 'production'
const isDevelopment = nodeEnv === 'development'

const config = safeLoad(readFileSync(configPath), 'utf8')
const availableEnvironments = Object.keys(config).join('|')
const regex = new RegExp(`^(${availableEnvironments})$`, 'g')

// v4 of webpack-dev-server will switch to WEBPACK_DEV_SERVE
// https://github.com/rails/webpacker/issues/3057
const runningWebpackDevServer = process.env.WEBPACK_DEV_SERVER === 'true' ||
  process.env.WEBPACK_DEV_SERVE === 'true'

module.exports = {
  railsEnv: railsEnv && railsEnv.match(regex) ? railsEnv : DEFAULT,
  nodeEnv,
  isProduction,
  isDevelopment,
  runningWebpackDevServer
}
