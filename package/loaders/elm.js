const { resolve } = require('path')

const elmSource = resolve(process.cwd())
const elmMake = `${elmSource}/node_modules/.bin/elm-make`
const elmDefaultOptions = {
  cwd: elmSource,
  pathToMake: elmMake
}

const elmWebpackLoader = {
  loader: 'elm-webpack-loader',
  options: elmDefaultOptions
}

const elmHotLoader = {
  loader: 'elm-hot-loader',
  options: {
    verbose: true,
    warn: true,
    debug: true
  }
}

const loaderOptions = () => {
  if (process.env.NODE_ENV === 'production') {
    return [elmWebpackLoader]
  }

  return [elmHotLoader, elmWebpackLoader]
}

module.exports = {
  test: /\.elm(\.erb)?$/,
  exclude: [/elm-stuff/, /node_modules/],
  use: loaderOptions()
}
