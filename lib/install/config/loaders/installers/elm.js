module.exports = {
  test: /\.elm$/,
  exclude: [/elm-stuff/, /node_modules/],
  loader: 'elm-hot-loader!elm-webpack-loader?verbose=true&warn=true&debug=true'
}
