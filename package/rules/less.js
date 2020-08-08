const getStyleRule = require('../utils/get_style_rule')
const { additional_paths: paths } = require('../config')

module.exports = getStyleRule(/\.(less)(\.erb)?$/i, [
  {
    loader: require.resolve('less-loader'),
    options: {
      lessOptions: {
        paths
      }
    }
  }
])
