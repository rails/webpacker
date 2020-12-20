const sass = require('sass')
const getStyleRule = require('../utils/get_style_rule')
const { additional_paths: includePaths } = require('../config')

module.exports = getStyleRule(/\.(scss|sass)(\.erb)?$/i, [
  {
    loader: require.resolve('sass-loader'),
    options: {
      sassOptions: { includePaths },
      implementation: sass
    }
  }
])
