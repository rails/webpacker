/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const Environment = require('./environment')
const { existsSync } = require('fs')

function createEnvironment() {
  const path = `./environments/${process.env.NODE_ENV}`
  const constructor = existsSync(path) ? require(path) : Environment
  return new constructor()
}

const environment = createEnvironment()

module.exports = { environment, Environment }
