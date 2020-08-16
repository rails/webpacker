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

const prepare = (name) => {
  try {
    require.resolve(name)
  } catch (e) {}
}

const availableRules = {
  file: file,
  url: url,
  css: css,
  sass: sass,
  babel: babel,
  erb: erb,
  coffee: coffee,
  elm: elm,
  svelte: svelte,
  vue: vue,
  html: html,
  eslint: eslint
}

Object.keys(availableRules)
