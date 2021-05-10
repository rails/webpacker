const path = require('path')
const config = require('../config')

const pathes = [config.source_path].concat(config.additional_paths)
pathes.sort((one, other) => other.split('/').length - one.split('/').length)

function subDir (assetPath) {
  const matchedPrefix = pathes.find(base => assetPath.startsWith(base))
  if (!matchedPrefix) return assetPath

  const localPath = assetPath.substr(matchedPrefix.length)

  if (localPath.startsWith('/')) {
    return localPath.substr(1)
  }

  return localPath
}

const outputPathPrefix = path.normalize(config.static_assets_output_prefix || 'media/images/')

function calculateFilename (pathData) {
  const dir = subDir(path.dirname(pathData.filename))
  return `${path.join(outputPathPrefix, dir)}/[name]-[hash][ext][query]`
}

const staticExtensionsTest =
  config.static_assets_extensions
    ? config.static_assets_extensions.map(ext => new RegExp(`${ext.replace('.', '\\.')}$`))
    : [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/, /\.tiff$/, /\.ico$/, /\.avif$/, /\.webp$/, /\.eot$/, /\.otf$/,
        /\.ttf$/, /\.woff$/, /\.woff2$/, /\.svg$/]

module.exports = {
  test: staticExtensionsTest,
  exclude: [/\.(js|mjs|jsx|ts|tsx)$/],
  type: 'asset/resource',
  generator: {
    filename: calculateFilename
  }
}
