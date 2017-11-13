const { resolve, join } = require('path')
const root = process.env.RAILS_ROOT || '';
const resolveRoot = (first, ...args) => first.startsWith('/')
  ? join(first, ...args)
  : resolve(root, first, ...args)


module.exports = {
  root,
  resolveRoot
}
