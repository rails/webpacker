/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */
const { moduleExists } = require('../utils/helpers')

module.exports = {
  test: /\.svg$/i,
  type: 'asset/inline',
  generator: {
    dataUrl: (content) => {
      let optimisedContent = content

      if (moduleExists('mini-svg-data-uri')) {
        const svgToMiniDataURI = require('mini-svg-data-uri')
        optimisedContent = svgToMiniDataURI(content.toString())
      }

      return optimisedContent
    }
  }
}
