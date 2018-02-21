/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { resolve } = require('path')
const { existsSync } = require('fs')
const Environment = require('./environments/base')
const loaders = require('./rules')
const env = require('./env')
const config = require('./config')
const devServer = require('./dev_server')

const createEnvironment = () => {
  const path = resolve(__dirname, 'environments', `${env}.js`)
  const constructor = existsSync(path) ? require(path) : Environment
  return new constructor()
}

module.exports = {
  config,
  devServer,
  environment: createEnvironment(),
  Environment,
  loaders
}
