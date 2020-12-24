/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */
const { moduleExists } = require('../utils/helpers')

module.exports = {
  test: [/\.svg$/],
  type: 'asset/inline'
}
