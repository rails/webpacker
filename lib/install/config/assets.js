// Handles static asset integration - like sass and images
// Note: You must restart bin/webpack-watcher for changes to take effect

const ExtractTextPlugin = require('extract-text-webpack-plugin')
const process = require('process')
const sharedConfig = require('./shared.js')
const { devServer } = require('../../package.json')

const production = process.env.NODE_ENV === 'production'
const hotServerAddr = `http://${devServer.host}:${devServer.port}/`

module.exports = {
  module: {
    rules: [
      {
        test: /\.(scss|sass|css)$/i,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', 'sass-loader']
        })
      },
      {
        test: /\.(jpeg|png|gif|svg|eot|svg|ttf|woff|woff2)$/i,
        use: [{
          loader: 'file-loader',
          options: {
            publicPath: devServer.enabled ? hotServerAddr : `/${sharedConfig.distDir}/`,
            name: production ? '[name]-[hash].[ext]' : '[name].[ext]'
          }
        }]
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin(
      production ? '[name]-[hash].css' : '[name].css'
    )
  ]
}
