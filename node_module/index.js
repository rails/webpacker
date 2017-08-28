const { existsSync } = require('fs')

function createEnvironmentInstance() {
  let path = `./environments/${process.env.NODE_ENV}`
  if (!existsSync(path)) {
    path = './environment'
  }
  const constructor = require(path)
  return new constructor
}

module.exports = createEnvironmentInstance()
