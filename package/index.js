/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const webpackMerge = require('webpack-merge')
const { resolve } = require('path')
const { existsSync } = require('fs')
const baseConfig = require('./environments/base')
const rules = require('./rules')
const config = require('./config')
const devServer = require('./dev_server')
const { nodeEnv } = require('./env')
const { moduleExists, canProcess } = require('./utils/helpers')
const inliningCss = require('./inliningCss')

const webpackConfig = () => {
  const path = resolve(__dirname, 'environments', `${nodeEnv}.js`)
  const environmentConfig = existsSync(path) ? require(path) : baseConfig
  return environmentConfig
}

module.exports = {
  config,
  devServer,
  webpackConfig: webpackConfig(),
  baseConfig,
  rules,
  moduleExists,
  canProcess,
  inliningCss,
  ...webpackMerge
}
