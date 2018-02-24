const styleRuleFactory = require('./style_rule_factory')

module.exports = styleRuleFactory(
  /\.(css)$/i,
  true,
  []
)
