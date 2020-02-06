const { environment } = require('@rails/webpacker')
environment.loaders.delete('typescript')

module.exports = environment
