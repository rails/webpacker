/* eslint no-console: 0 */
/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

// Fetch NODE_ENV or setup default to test
process.env.NODE_ENV = process.env.NODE_ENV || 'test'

const chalk = require('chalk')
const webpack = require('webpack')
let webpackConfig = require('../config/webpack/test')
const config = require('../config')
const getConfig = require('../utils/get-config')
const logErrors = require('../utils/log-errors')

const appConfig = getConfig()

if (appConfig.webpack) {
  console.log(`${chalk.blue('[webpacker]')} ${chalk.cyan('Using "webpack" config function defined in webpack.config.js.')}`)
  webpackConfig = appConfig.webpack(webpackConfig, config)
}

// Compile and build a test bundle
const build = () => {
  console.log(`${chalk.blue('[webpacker]')} ${chalk.cyan('Building a test bundle...')}`)
  webpack(webpackConfig).run((err, stats) => {
    const info = stats.toJson()

    if (err) {
      logErrors('Failed to compile.', [err])
      process.exit(1)
    }

    if (stats.hasWarnings()) {
      console.log(`${chalk.blue('[webpacker]')} ${chalk.yellow('Compiled with warnings.')}`)
      logErrors(info.warnings)
    }

    if (stats.hasErrors()) {
      console.log(`${chalk.blue('[webpacker]')} ${chalk.red('Failed to compile.')}`)
      logErrors(info.errors)
      process.exit(1)
    }

    console.log()
    console.log(`${chalk.blue('[webpacker]')} ${chalk.green('Test build succeeded 🎉')}`)
    console.log(`${chalk.blue('[webpacker]')} The test bundles are emitted to:`)
    console.log(`${chalk.blue('[webpacker]')} ${chalk.green(config.outputPath)}`)
    console.log()
    console.log(`${chalk.blue('[webpacker]')} The test bundles are:`)
    console.log(`${chalk.blue('[webpacker]')} ${chalk.green(JSON.stringify(require(config.manifestPath)))}`)
  })
}

// Start the webpack build process
build()
