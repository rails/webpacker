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

const moduleExists = (packageName) => {
  try {
    return require.resolve(packageName)
  } catch (e) {
    if (e.code !== 'MODULE_NOT_FOUND') {
      throw e
    }
    return null
  }
}

const canProcess = (rule, fn) => {
  const modulePath = moduleExists(rule)

  if (modulePath) {
    return fn(modulePath)
  }

  return null
}

module.exports = {
  chdirTestApp,
  chdirCwd,
  isArray,
  isBoolean,
  ensureTrailingSlash,
  canProcess,
  moduleExists,
  resetEnv
}
