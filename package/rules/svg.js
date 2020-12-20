const svgToMiniDataURI = require('mini-svg-data-uri')

module.exports = {
  test: /\.svg$/i,
  type: 'asset/inline',
  generator: { dataUrl: (content) => svgToMiniDataURI(content.toString()) }
}
