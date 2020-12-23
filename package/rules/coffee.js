const { canProcess } = require('../utils/helpers')

module.exports = canProcess('coffee-loader', (resolvedPath) => ({
  test: /\.coffee(\.erb)?$/,
  use: [{ loader: resolvedPath }]
}))
