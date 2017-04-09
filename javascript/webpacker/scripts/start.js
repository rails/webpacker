/* eslint no-console: 0 */

// Fetch NODE_ENV or setup default to production
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const addDevServerEntrypoints = require('webpack-dev-server/lib/util/addDevServerEntrypoints')
const chalk = require('chalk')
const detect = require('detect-port')
const Webpack = require('webpack')
const WebpackDevServer = require('webpack-dev-server')
let webpackConfig = require('../config/webpack/development')
const config = require('../config')
const getConfig = require('../utils/get-config')
const logErrors = require('../utils/log-errors')

const appConfig = getConfig()

if (appConfig.webpack) {
  console.log(`${chalk.blue('[webpacker]')} ${chalk.cyan('Using "webpack" config function defined in webpack.config.js.')}`)
  webpackConfig = appConfig.webpack(webpackConfig, config)
}

// Make dev entries hot
addDevServerEntrypoints(webpackConfig, webpackConfig.devServer)

// Setup compiler with hot entries
const compiler = Webpack(webpackConfig, (err, stats) => {
  const info = stats.toJson()

  if (err) {
    console.log(`${chalk.blue('[webpacker]')} ${chalk.red('Failed to compile.')}`)
    console.error(`${chalk.blue('[webpacker]')} ${chalk.red(err.stack || err)}`)
    console.log(`${chalk.blue('[webpacker]')} ${chalk.red(err.details)}`)
    return
  }

  if (stats.hasErrors()) {
    console.log(`${chalk.blue('[webpacker]')} ${chalk.red('Failed to compile.')}`)
    logErrors(info.errors)
    return
  }

  if (stats.hasWarnings()) {
    console.log(`${chalk.blue('[webpacker]')} ${chalk.yellow('Compiled with warnings.')}`)
    logErrors(info.warnings)
  }

  console.log(`${chalk.blue('[webpacker]')} ${chalk.green('Compiled successfully!')}`)
  console.log()
  console.log(`${chalk.blue('[webpacker]')} The webpack-dev-server is serving assets at:`)
  console.log()
  console.log(`${chalk.blue('[webpacker]')} ${config.publicPath}`)
  console.log()
})

const run = () => {
  // Initialize webpack-dev-server with compiler and dev server options
  const webpackDevServer = new WebpackDevServer(compiler, webpackConfig.devServer)

  // Launch webpack-dev-server on configured port and host
  webpackDevServer.listen(config.devServer.port, (err) => {
    if (err) { console.log(chalk.red(err)) }
    console.log(`${chalk.blue('[webpacker]')} ${chalk.cyan('Starting the webpack dev server...')}`)
    console.log()
  })
}

// Check port and call function to run webpack-dev-server
detect(config.devServer.port).then((port) => {
  if (config.devServer.port === port) {
    run()
  } else {
    console.log(`${chalk.blue('[webpacker]')} ${chalk.red(`Another application is using port ${config.devServer.port}.`)}`)
    process.exit(1)
  }
})

// Respect stdin
process.stdin.resume()
process.stdin.on('end', () => { process.exit(0) })
