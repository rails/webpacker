const babel = require('./babel')
const file = require('./file')
const css = require('./css')
const sass = require('./sass')
const erb = require('./erb')
const coffee = require('./coffee')
const elm = require('./elm')
const svelte = require('./svelte')
const vue = require('./vue')
const html = require('./html')
const eslint = require('./eslint')
const url = require('./url')

module.exports = {
  file,
  url,
  css,
  sass,
  babel,
  erb,
  coffee,
  elm,
  svelte,
  vue,
  html,
  eslint
}
