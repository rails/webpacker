const url = require('url')

const computeAssetUrl = (host) => {
  if (host) {
    const parsedHost = url.parse(host)
    if (parsedHost.slashes) { return parsedHost.href }
    return `//${parsedHost.href.replace('//', '')}/`
  }

  return host
}

module.exports = computeAssetUrl
