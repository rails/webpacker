const { resolve } = require('path')

export default process.env.WEBPACKER_CONFIG || resolve('config', 'webpacker.yml')
