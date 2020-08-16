const TerserPlugin = require('terser-webpack-plugin')

module.exports = new TerserPlugin({
  parallel: Number.parseInt(process.env.WEBPACKER_PARALLEL, 10) || true,
  cache: true,
  sourceMap: true,
  terserOptions: {
    parse: {
      // Let terser parse ecma 8 code but always output
      // ES5 compliant code for older browsers
      ecma: 8
    },
    compress: {
      ecma: 5,
      warnings: false,
      comparisons: false
    },
    mangle: {
      safari10: true
    },
    output: {
      ecma: 5,
      comments: false,
      ascii_only: true
    }
  }
})
