const babelLoader = require('./babel')

module.exports = {
  test: /.vue$/,
  loader: 'vue-loader',
  options: {
    extractCSS: true,
    loaders: {
      js: `babel-loader?${JSON.stringify(babelLoader.options)}`,
      file: 'file-loader',
      scss: 'vue-style-loader!css-loader!postcss-loader!sass-loader',
      sass: 'vue-style-loader!css-loader!postcss-loader!sass-loader?indentedSyntax'
    }
  }
}
