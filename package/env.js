const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync, existsSync } = require('fs')

const NODE_ENVIRONMENTS = ['development', 'production', 'test']
const DEFAULT = 'production'

let configPath

if (existsSync('config/webpacker.yml')) {
  configPath = resolve('config', 'webpacker.yml')
} else {
  configPath = require.resolve('../lib/install/config/webpacker.yml')
}

const railsEnv = process.env.RAILS_ENV
const nodeEnv = process.env.NODE_ENV

const config = safeLoad(readFileSync(configPath), 'utf8')
const availableEnvironments = Object.keys(config).join('|')
const regex = new RegExp(`^(${availableEnvironments})$`, 'g')

module.exports = {
  railsEnv: railsEnv && railsEnv.match(regex) ? railsEnv : DEFAULT,
  nodeEnv: nodeEnv && NODE_ENVIRONMENTS.includes(nodeEnv) ? nodeEnv : DEFAULT
}
