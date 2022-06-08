const path = require('path')
const { canProcess } = require('../utils/helpers')
const getStyleRule = require('../utils/get_style_rule')

const {
  additional_paths: paths,
  source_path: sourcePath
} = require('../config')

module.exports = canProcess('less-loader', (resolvedPath) =>
  getStyleRule(/\.(less)(\.erb)?$/i, [
    {
      loader: resolvedPath,
      options: {
        lessOptions: {
          paths: [path.resolve(__dirname, 'node_modules'), sourcePath, ...paths]
        },
        sourceMap: true
      }
    }
  ])
)
