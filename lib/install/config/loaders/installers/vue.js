const ExtractTextPlugin = require('extract-text-webpack-plugin')
const { env } = require('../configuration.js')

// Change it to false if you prefer Vue styles to be inlined by javascript in runtime
const extractStyles = false

const cssLoader = [
  { loader: 'css-loader', options: { minimize: env.NODE_ENV === 'production' } },
  { loader: 'postcss-loader', options: { sourceMap: true } },
  'resolve-url-loader'
]
const sassLoader = cssLoader.concat([
  { loader: 'sass-loader', options: { sourceMap: true, indentedSyntax: true } }
])
const scssLoader = cssLoader.concat([
  { loader: 'sass-loader', options: { sourceMap: true } }
])

function vueStyleLoader(loader) {
  if (extractStyles) {
    return ExtractTextPlugin.extract({
      fallback: 'vue-style-loader',
      use: loader
    })
  }
  return ['vue-style-loader'].concat(loader)
}

module.exports = {
  test: /.vue$/,
  loader: 'vue-loader',
  options: {
    loaders: {
      js: 'babel-loader',
      file: 'file-loader',
      css: vueStyleLoader(cssLoader),
      scss: vueStyleLoader(scssLoader),
      sass: vueStyleLoader(sassLoader)
    }
  }
}
