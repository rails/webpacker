const { join, resolve } = require('path')
const { cache_path: cachePath, source_path: sourcePath } = require('../config')
const { nodeEnv } = require('../env')

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
        cacheDirectory: join(cachePath, 'babel-loader-node-modules'),
        cacheCompression: nodeEnv === 'production',
        compact: nodeEnv === 'production'
      }
    }
  ]
}
