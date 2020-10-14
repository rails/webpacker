const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const NODE_ENVIRONMENTS = ['development', 'production', 'test']
const DEFAULT = 'production'
const configPath = require('./configPath')

const railsEnv = process.env.RAILS_ENV
const rawNodeEnv = process.env.NODE_ENV
const nodeEnv = rawNodeEnv && NODE_ENVIRONMENTS.includes(rawNodeEnv) ? rawNodeEnv : DEFAULT
const isProduction = nodeEnv === 'production'

const config = safeLoad(readFileSync(configPath), 'utf8')
const availableEnvironments = Object.keys(config).join('|')
const regex = new RegExp(`^(${availableEnvironments})$`, 'g')

module.exports = {
  railsEnv: railsEnv && railsEnv.match(regex) ? railsEnv : DEFAULT,
  nodeEnv,
  isProduction
}
