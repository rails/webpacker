const { resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const filePath = resolve('config', 'webpacker.yml')
const config = safeLoad(readFileSync(filePath), 'utf8')

module.exports = config[process.env.NODE_ENV]
