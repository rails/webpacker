module.exports = {
  test: /\.html$/,
  use: [
    {
      loader: require.resolve('html-loader'),
      options: {
        minimize: true,
        removeAttributeQuotes: false,
        caseSensitive: true,
        customAttrSurround: [
          [/#/, /(?:)/],
          [/\*/, /(?:)/],
          [/\[?\(?/, /(?:)/]
        ],
        customAttrAssign: [/\)?\]?=/]
      }
    }
  ]
}
