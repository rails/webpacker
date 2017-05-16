const path = require('path')
const { env } = require('../configuration.js')

const elmSource = path.resolve(process.cwd())
const elmMake = `${elmSource}/node_modules/.bin/elm-make`
const elmDefaultOptions = `cwd=${elmSource}&pathToMake=${elmMake}`

const loaderOptions = () => {
  if (env.NODE_ENV === 'production') {
    return `elm-webpack-loader?${elmDefaultOptions}`
  }

  return `elm-hot-loader!elm-webpack-loader?${elmDefaultOptions}&verbose=true&warn=true&debug=true`
}

module.exports = {
  test: /\.elm$/,
  exclude: [/elm-stuff/, /node_modules/],
  loader: loaderOptions()
}
