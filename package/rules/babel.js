const { join, resolve } = require('path')
const { cache_path: cachePath, source_path: sourcePath } = require('../config')

// Process application Javascript code with Babel.
// Uses application .babelrc to apply any transformations
module.exports = {
  test: /\.(js|jsx|mjs)?(\.erb)?$/,
  include: resolve(sourcePath),
  exclude: /node_modules/,
  use: [
    {
      loader: 'babel-loader',
      options: {
        highlightCode: true,
        compact: true,
        cacheDirectory: join(cachePath, 'babel-loader-app')
      }
    }
  ]
}
