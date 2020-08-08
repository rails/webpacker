module.exports = {
  test: /\.coffee(\.erb)?$/,
  use: [
    {
      loader: require.resolve('coffee-loader')
    }
  ]
}
