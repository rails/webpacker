const { canProcess } = require('../utils/helpers')

const runner = /^win/.test(process.platform) ? 'ruby ' : ''

module.exports = canProcess('rails-erb-loader', (resolvedPath) => ({
  test: /\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [
    {
      loader: resolvedPath,
      options: { runner: `${runner}bin/rails runner` }
    }
  ]
}))
