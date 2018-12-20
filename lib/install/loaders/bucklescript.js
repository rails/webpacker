module.exports = {
  test: /\.(re|ml)(\.erb)?$/,
  use: [{
    loader: 'bs-loader',
    options: {
      module: 'es6',
      inSource: true
    }
  }]
}
