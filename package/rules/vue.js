module.exports = {
  test: /\.vue(\.erb)?$/,
  use: [
    {
      loader: require.resolve('vue-loader')
    }
  ]
}
