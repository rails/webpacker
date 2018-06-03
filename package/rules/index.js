const babel = require('./babel')
const nodeModules = require('./node_modules')
const file = require('./file')
const css = require('./css')
const sass = require('./sass')
const moduleCss = require('./module.css')
const moduleSass = require('./module.sass')

module.exports = {
  file,
  css,
  sass,
  moduleCss,
  moduleSass,
  nodeModules,
  babel
}
