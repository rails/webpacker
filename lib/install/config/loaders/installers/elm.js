const path = require('path')
const { env } = require('../configuration.js')

const elmSource = path.resolve(process.cwd())
const elmLoader = env.NODE_ENV === 'production' ?  'elm-webpack-loader' : 'elm-hot-loader!elm-webpack-loader'
const debug = env.NODE_ENV === 'production' ? 'false' : 'true'

module.exports = {
  test: /\.elm$/,
  exclude: [/elm-stuff/, /node_modules/],
  loader: `${elmLoader}?verbose=true&warn=true&debug=${debug}&cwd=${elmSource}`
}
