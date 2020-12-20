const MiniCssExtractPlugin = require('mini-css-extract-plugin')

const tryPostcss = () => {
  let postcssLoader = false
  try {
    if (require.resolve('postcss-loader')) {
      postcssLoader = {
        loader: require.resolve('postcss-loader'),
        options: { sourceMap: true }
      }
    }
  } catch (e) {
    /* Work out what to print here */
  }

  return postcssLoader
}

const getStyleRule = (test, preprocessors = []) => {
  const use = [
    { loader: MiniCssExtractPlugin.loader },
    {
      loader: require.resolve('css-loader'),
      options: {
        sourceMap: true,
        importLoaders: 2
      }
    },
    tryPostcss(),
    ...preprocessors
  ].filter(Boolean)

  return {
    test,
    use
  }
}

module.exports = getStyleRule
