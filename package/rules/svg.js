module.exports = {
  test: /\.svg$/i,
  use: [
    {
      loader: require.resolve('url-loader'),
      options: {
        generator: (content) => require.resolve('mini-svg-data-uri')(content.toString())
      }
    }
  ]
}
