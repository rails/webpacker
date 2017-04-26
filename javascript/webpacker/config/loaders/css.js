const ExtractTextPlugin = require('extract-text-webpack-plugin')
const { removeEmpty, propIf } = require('webpack-config-utils')
const { ifProduction, ifDevelopment, settings } = require('../index')

const loaderOptions = {
  fallback: 'style-loader',
  use: removeEmpty([{
    loader: 'css-loader',
    // Add optional css-modules support
    // Documentation https://github.com/css-modules/css-modules
    options: removeEmpty({
      modules: settings.css_modules,
      minimize: ifProduction(),
      // Use a local class name if css modules are enabled
      localIdentName: propIf(
        settings.css_modules,
        '[path][name]__[local]--[hash:base64:5]',
        undefined
      )
    })
  },
    // Toggle postcss and sass support
    propIf(settings.postcss, 'postcss-loader', undefined),
    propIf(settings.sass, 'sass-loader', undefined)
  ])
}

// For development use regular loaders else use extract-text-plugin
module.exports = propIf(ifDevelopment(), {
  test: /\.(scss|sass|css)$/i,
  use: ['style-loader'].concat(loaderOptions.use)
}, {
  test: /\.(scss|sass|css)$/i,
  use: ExtractTextPlugin.extract(loaderOptions)
})
