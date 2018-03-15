/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { resolve } = require('path')
const { existsSync, readFileSync } = require('fs')
const { safeLoad } = require('js-yaml')
const Environment = require('./environments/base')
const loaders = require('./rules')
const env = require('./env')
const config = require('./config')

const configPath = resolve('config', 'webpacker.yml')
const devServer = require('./dev_server')

const appConfig = safeLoad(readFileSync(configPath), 'utf8')
const app = appConfig && appConfig[env]
const webpackerEnv = (app && app.extend_default_env) || env

const createEnvironment = (baseEnv) => {
  const path = resolve(__dirname, 'environments', `${baseEnv}.js`)
  const constructor = existsSync(path) ? require(path) : Environment
  return new constructor()
}

module.exports = {
  config,
  devServer,
  environment: createEnvironment(webpackerEnv),
  Environment,
  loaders
}
