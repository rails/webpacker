const webpack = require('webpack')

module.exports = new webpack.EnvironmentPlugin(process.env)
