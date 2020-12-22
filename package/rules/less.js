const path = require('path')

const getStyleRule = require('../utils/get_style_rule')
const { packagePath } = require('../utils/helpers')
const {
  additional_paths: paths,
  source_path: sourcePath
} = require('../config')

module.exports = getStyleRule(/\.(less)(\.erb)?$/i, [
  {
    loader: packagePath('less-loader'),
    options: {
      lessOptions: {
        paths: [path.resolve(__dirname, 'node_modules'), sourcePath, ...paths]
      },
      sourceMap: true
    }
  }
])
