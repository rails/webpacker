const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const Base = require('./base')

module.exports = class extends Base {
  constructor() {
    super()
    
    this.config.merge({
      devtool: 'nosources-source-map',
      stats: 'normal',
      bail: true,
      optimization: {
        minimizer: [
          new UglifyJsPlugin({
            parallel: true,
            cache: true,
            sourceMap: false,
            uglifyOptions: {
              ecma: 5,
              compress: false,
              output: {
                comments: false,
                ascii_only: true
              },
              safari10: true
            }
          })
        ]
      }
    })
  }
}
