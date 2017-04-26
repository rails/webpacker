// export all webpack configurations

const config = require('./config')
const development = require('./config/webpack/development')
const production = require('./config/webpack/production')
const test = require('./config/webpack/test')

module.exports = {
  config,
  development,
  production,
  test
}
