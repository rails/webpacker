const Brotli = require('./brotli')
const CaseSensitivePaths = require('./case_sensitive_paths')
const Environment = require('./environment')
const Gzip = require('./gzip')
const HotModuleReplacement = require('./hot_module_replacement')
const MiniCssExtract = require('./mini_css_extract')
const OptimizeCssAssets = require('./optimize_css_assets')
const WebpackAssetsManifest = require('./webpack_assets_manifest')
const PnpWebpack = require('./pnp')

const compressionPlugins = [Gzip]
if ('brotli' in process.versions) compressionPlugins.push(Brotli)

module.exports = {
  shared: [
    Environment,
    CaseSensitivePaths,
    MiniCssExtract,
    WebpackAssetsManifest,
    PnpWebpack
  ],
  development: {
    hot: [HotModuleReplacement]
  },
  production: [...compressionPlugins, OptimizeCssAssets]
}
