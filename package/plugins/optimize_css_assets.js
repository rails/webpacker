const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const safePostCssParser = require('postcss-safe-parser')

module.exports = new OptimizeCSSAssetsPlugin({
  parser: safePostCssParser,
  map: {
    inline: false,
    annotation: true
  }
})
