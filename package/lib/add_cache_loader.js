const config = require('../config')
const { join } = require('path')

const cacheLoader = {
  loader: 'cache-loader',
  options: {
    cacheDirectory: join(config.cache_path, 'cache-loader')
  }
}

module.exports = function(loader) {
  if (loader.use) {
    loader.use.unshift(cacheLoader)
  } else if (loader.loader) {
    let ruleLoader = null
    if (loader.options) {
      ruleLoader = { loader: loader.loader, options: loader.options }
      delete loader.options
    }
    loader.use = [cacheLoader, ruleLoader || loader.loader]
    delete loader.loader
  }
}
