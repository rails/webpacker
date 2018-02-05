const styleRuleFactory = require('./style_rule_factory')

module.exports = styleRuleFactory(
  /\.(scss|sass)$/i,
  true,
  [{
    loader: 'sass-loader',
    options: { sourceMap: true }
  }]
)
