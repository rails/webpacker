const isArray = (value) => Array.isArray(value)
const isBoolean = (str) => /^true/.test(str) || /^false/.test(str)
const isNumber = (str) => /^-?\d+(\.\d+)?$/.test(str)
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

const asBoolean = (str) => {
  if (/^true/.test(str)) return true
  return false
}

const asBooleanOrNumber = (value) => {
  if (isBoolean(value)) return asBoolean(value)
  if (isNumber(value)) return Number(value)
  throw new Error(`${value} is not boolean or numeric strings`)
}

module.exports = {
  asBooleanOrNumber,
  chdirTestApp,
  chdirCwd,
  isArray,
  isBoolean,
  isNumber,
  ensureTrailingSlash,
  canProcess,
  moduleExists,
  resetEnv
}
