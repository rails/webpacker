const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const configPath = resolve('config', 'webpacker.yml')
const DEFAULT_ENV = 'production'

const env = () => {
  const nodeEnv = process.env.NODE_ENV
  const railsEnv = process.env.RAILS_ENV
  const config = safeLoad(readFileSync(configPath), 'utf8')
  const availableEnvironments = Object.keys(config).join('|')
  const regex = new RegExp(availableEnvironments, 'g')

  if (nodeEnv && nodeEnv.match(regex)) return nodeEnv
  if (railsEnv && railsEnv.match(regex)) return railsEnv

  /* eslint no-console: 0 */
  console.warn(`NODE_ENV=${nodeEnv} and RAILS_ENV=${railsEnv} environment is not defined in config/webpacker.yml, falling back to ${DEFAULT_ENV}`)
  return DEFAULT_ENV
}

module.exports = env()
