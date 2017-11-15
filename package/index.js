/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { resolve } = require('path')
const { existsSync } = require('fs')
const Environment = require('./environment')
const config = require('./config')
const assetHost = require('./asset_host')
const loaders = require('./rules')

const createEnvironment = () => {
  const path = resolve(__dirname, 'environments', `${process.env.NODE_ENV}.js`)
  const constructor = existsSync(path) ? require(path) : Environment
  return new constructor()
}

const environment = createEnvironment()

module.exports = { environment, config, assetHost, loaders, Environment }
