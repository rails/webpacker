/* global test expect, describe */

const { chdirTestApp, chdirCwd } = require('../utils/helpers')
const EXPECTED_EXTENSIONS = [
  '.js',
  '.sass',
  '.scss',
  '.css',
  '.module.sass',
  '.module.scss',
  '.module.css',
  '.png',
  '.svg',
  '.gif',
  '.jpeg',
  '.jpg'
]

chdirTestApp()

describe('Config', () => {
  beforeEach(() => jest.resetModules())
  afterAll(chdirCwd)

  test('should return extensions as listed in app config', () => {
    expect(require('../config').extensions).toEqual(EXPECTED_EXTENSIONS)
  })

  test('should return extensions as listed in app config for custom environment', () => {
    process.env.NODE_ENV = 'qa2'
    expect(require('../config').extensions).toEqual(EXPECTED_EXTENSIONS)
  })
})
