/* eslint no-console: 0 */
const chalk = require('chalk')

// Function to log errors in console
const logErrors = (errors) => {
  errors.forEach((err) => {
    console.log(`${chalk.blue('[webpacker]')} ${chalk.red(err.message || err)}`)
    console.log()
  })
}

module.exports = logErrors
