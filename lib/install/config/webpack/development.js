const environment = require('./environment')

const config = environment.toWebpackConfig()
config.devtool = 'cheap-module-source-map'

module.exports = config
