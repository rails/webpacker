process.env.NODE_ENV = process.env.NODE_ENV || 'test'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
