/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const load = (name) => {
  try {
    return require(`./${name}`)
  } catch (e) {
    return null
  }
}

const rules = {
  file: load('file'),
  svg: load('svg'),
  css: load('css'),
  sass: load('sass'),
  babel: load('babel'),
  erb: load('erb'),
  coffee: load('coffee'),
  html: load('html'),
  less: load('less')
}

module.exports = Object.keys(rules)
  .filter((key) => !!rules[key])
  .map((key) => rules[key])
