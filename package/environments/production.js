const Base = require('./base')

module.exports = class extends Base {
  constructor() {
    super()

    this.config.merge({
      stats: 'normal',
      bail: true
    })
  }
}
