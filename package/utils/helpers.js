const isArray = (value) => Array.isArray(value)
const isBoolean = (str) => /^true/.test(str) || /^false/.test(str)
const chdirTestApp = () => {
  try {
    return process.chdir('test/test_app')
  } catch (e) {
    return null
  }
}

const chdirCwd = () => process.chdir(process.cwd())

const resetEnv = () => {
  process.env = {}
}

const ensureTrailingSlash = (path) => (path.endsWith('/') ? path : `${path}/`)

const resolvedPath = (packageName) => {
  try {
    return require.resolve(packageName)
  } catch (e) {
    if (e.code !== 'MODULE_NOT_FOUND') {
      throw e
    }
    return null
  }
}

const moduleExists = (packageName) => (!!resolvedPath(packageName))

const canProcess = (rule, fn) => {
  const modulePath = resolvedPath(rule)

  if (modulePath) {
    return fn(modulePath)
  }

  return null
}

// v4 of webpack-dev-server will switch to WEBPACK_DEV_SERVE
// https://github.com/rails/webpacker/issues/3057
const runningWebpackDevServer = process.env.WEBPACK_DEV_SERVER === 'true' ||
  process.env.WEBPACK_DEV_SERVE === 'true'

module.exports = {
  chdirTestApp,
  chdirCwd,
  isArray,
  isBoolean,
  ensureTrailingSlash,
  canProcess,
  moduleExists,
  resetEnv,
  runningWebpackDevServer
}
