const getStyleRule = (test, preprocessors = []) => {
  const use = [
    require.resolve('mini-css-extract-plugin').loader,
    {
      loader: require.resolve('css-loader'),
      options: {
        sourceMap: true,
        importLoaders: 2
      }
    },
    {
      loader: require.resolve('postcss-loader'),
      options: {
        sourceMap: true
      }
    },
    ...preprocessors
  ]

  return {
    test,
    use
  }
}

module.exports = getStyleRule
