const merge = require('webpack-merge')
const baseConfig = require('./base')
const plugins = require('../plugins')
const Terser = require('../plugins/terser')

const productionConfig = {
  devtool: 'source-map',
  stats: 'normal',
  bail: true,
  plugins: plugins.production,
  optimization: {
    minimizer: [Terser]
  }
}

module.exports = merge(baseConfig, productionConfig)
