/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

module.exports = {
  test: /\.svg$/i,
  type: 'asset/inline',
  generator: {
    dataUrl: (content) => {
      let optimisedContent = content

      try {
        if (require.resolve('mini-svg-data-uri')) {
          const svgToMiniDataURI = require('mini-svg-data-uri')
          optimisedContent = svgToMiniDataURI(content.toString())
        }
      } catch (e) {
        /* Work out what to print here */
      }

      return optimisedContent
    }
  }
}
