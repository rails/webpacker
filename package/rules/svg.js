const svgToMiniDataURI = require('mini-svg-data-uri')

module.exports = {
  module: {
    rules: [
      {
        test: /\.svg$/i,
        use: [
          {
            loader: require.resolve('url-loader'),
            options: {
              generator: (content) => svgToMiniDataURI(content.toString())
            }
          }
        ]
      }
    ]
  }
}
