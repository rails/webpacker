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

const packagePath = (packageName) => {
  try {
    return require.resolve(packageName)
  } catch (e) {
    if (e.code !== 'MODULE_NOT_FOUND' || e.moduleName !== packageName) {
      throw e
    }
    return null
  }
}

const loaderCheckingExists = (loader, fn) => {
  const loaderPath = packagePath(loader)
  if (loaderPath) {
    return fn(loaderPath)
  }
  return null
}

module.exports = {
  chdirTestApp,
  chdirCwd,
  isArray,
  isBoolean,
  ensureTrailingSlash,
  loaderCheckingExists,
  packagePath,
  resetEnv
}
