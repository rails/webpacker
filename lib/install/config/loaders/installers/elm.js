const path = require('path')
const { env } = require('../configuration.js')

const elmSource = path.resolve(process.cwd())

const loaderOptions = () => {
  if (['development', 'test'].includes(env.NODE_ENV)) {
    return `elm-hot-loader!elm-webpack-loader?cwd=${elmSource}&verbose=true&warn=true&debug=true`
  }

  return `elm-webpack-loader?cwd=${elmSource}`
}

module.exports = {
  test: /\.elm$/,
  exclude: [/elm-stuff/, /node_modules/],
  loader: loaderOptions()
}
