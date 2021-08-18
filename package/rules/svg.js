module.exports = {
  test: /\.svg/,
  type: 'asset/inline',
  generator: {
    dataUrl: content => {
      content = content.toString();
      
      if (require.resolve("mini-svg-data-uri")) {
        const svgToMiniDataURI = require('mini-svg-data-uri');
        content = svgToMiniDataURI(content)
      }

      return content;
    }
  }
}