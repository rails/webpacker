module.exports = {
  test: /.vue$/,
  loader: 'vue-loader',
  options: {
    loaders: {
      js: 'babel-loader!eslint-loader',
      file: 'file-loader',
      scss: 'vue-style-loader!css-loader!postcss-loader!sass-loader',
      sass: 'vue-style-loader!css-loader!postcss-loader!sass-loader?indentedSyntax'
    }
  }
}
