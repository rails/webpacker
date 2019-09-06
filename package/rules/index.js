const babel = require('./babel')
const file = require('./file')
const css = require('./css')
const sass = require('./sass')
const moduleCss = require('./module.css')
const moduleSass = require('./module.sass')

// Webpack rules are processed in reverse order
// https://webpack.js.org/concepts/loaders/#loader-features
// Lastly, process static files using file rule
module.exports = {
  file,
  css,
  sass,
  moduleCss,
  moduleSass,
  babel
}
