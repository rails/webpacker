/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const rules = {
  file: require('./file'),
  svg: require('./svg'),
  css: require('./css'),
  sass: require('./sass'),
  babel: require('./babel'),
  erb: require('./erb'),
  coffee: require('./coffee'),
  less: require('./less')
}

module.exports = Object.keys(rules)
  .filter((key) => !!rules[key])
  .map((key) => rules[key])
