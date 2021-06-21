const { runningWebpackDevServer } = require('./env')
const devServer = require('./dev_server')

// This logic is tied to lib/webpacker/instance.rb
const inliningCss = runningWebpackDevServer && devServer.hmr

module.exports = inliningCss
