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
  url: load('url'),
  css: load('css'),
  sass: load('sass'),
  babel: load('babel'),
  erb: load('erb'),
  coffee: load('coffee'),
  elm: load('elm'),
  svelte: load('svelte'),
  vue: load('vue'),
  html: load('html'),
  eslint: load('eslint'),
  svg: load('svg'),
  less: load('less')
}

module.exports = Object.keys(rules)
  .filter((key) => !!rules[key])
  .map((key) => rules[key])
