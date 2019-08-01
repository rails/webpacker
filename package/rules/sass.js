const getStyleRule = require('../utils/get_style_rule')
const { resolved_paths: includePaths } = require('../config')

module.exports = getStyleRule(/\.(scss|sass)$/i, false, [
  {
    loader: 'sass-loader',
    options: { sourceMap: true, includePaths }
  }
])
