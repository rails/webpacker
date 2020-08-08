module.exports = {
  test: /\.svelte(\.erb)?$/,
  use: [
    {
      loader: require.resolve('svelte-loader'),
      options: {
        hotReload: false
      }
    }
  ]
}
