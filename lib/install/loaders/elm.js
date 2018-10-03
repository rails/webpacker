const { resolve } = require('path')

const isProduction = process.env.NODE_ENV === 'production'
const elmSource = resolve(process.cwd())
const elmBinary = `${elmSource}/node_modules/.bin/elm`

const elmDefaultOptions = { cwd: elmSource, pathToElm: elmBinary }
const developmentOptions = Object.assign({}, elmDefaultOptions, {
  verbose: true,
  debug: true
})

const elmWebpackLoader = {
  loader: 'elm-webpack-loader',
  options: isProduction ? elmDefaultOptions : developmentOptions
}

module.exports = {
  test: /\.elm(\.erb)?$/,
  exclude: [/elm-stuff/, /node_modules/],
  use: isProduction ? [elmWebpackLoader] : [{ loader: 'elm-hot-webpack-loader' }, elmWebpackLoader]
}
