const runner = /^win/.test(process.platform) ? 'ruby ' : ''

module.exports = {
  test: /\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [
    {
      loader: require.resolve('rails-erb-loader'),
      options: {
        runner: `${runner}bin/rails runner`
      }
    }
  ]
}
