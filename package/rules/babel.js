const { resolve } = require('path')
const { realpathSync } = require('fs')

const {
  source_path: sourcePath,
  additional_paths: additionalPaths
} = require('../config')
const { isProduction } = require('../env')

module.exports = {
  test: /\.(js|jsx|mjs|ts|tsx|coffee)?(\.erb)?$/,
  include: [sourcePath, ...additionalPaths].map((p) => {
    try {
      return realpathSync(p)
    } catch (e) {
      return resolve(p)
    }
  }),
  exclude: /node_modules/,
  use: [
    {
      loader: require.resolve('babel-loader'),
      options: {
        cacheDirectory: true,
        cacheCompression: isProduction,
        compact: isProduction
      }
    }
  ]
}
