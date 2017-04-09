/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { join } = require('path')
const { existsSync } = require('fs')
const { appConfigPath } = require('../config')

const cache = new Map()

const loadConfig = () => {
  const path = join(appConfigPath, 'webpack.config.js')
  let appConfig = {}
  if (existsSync(path)) { appConfig = require(path) }

  return appConfig
}

const getConfig = () => {
  if (!cache.has(appConfigPath)) { cache.set(appConfigPath, loadConfig()) }
  return cache.get(appConfigPath)
}

module.exports = getConfig
