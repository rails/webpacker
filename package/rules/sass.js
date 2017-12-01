const cssLoader = require('./css')
const deepMerge = require('../utils/deep_merge')

// Duplicate and remove css loader object reference
let sassLoader = JSON.parse(JSON.stringify(cssLoader))

sassLoader = deepMerge(sassLoader, {
  test: /\.(scss|sass)$/i,
  use: [{
    loader: 'sass-loader',
    options: { sourceMap: true }
  }]
})

module.exports = sassLoader
