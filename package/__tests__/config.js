/* global test expect, describe */

const chdirApp = () => process.chdir('test/test_app')
const chdirCwd = () => process.chdir(process.cwd())
chdirApp()

const config = require('../config')

describe('Webpacker.yml config', () => {
  afterAll(chdirCwd)

  test('should return extensions as listed in app config', () => {
    expect(config.extensions).toEqual([
      '.js',
      '.sass',
      '.scss',
      '.css',
      '.png',
      '.svg',
      '.gif',
      '.jpeg',
      '.jpg'
    ])
  })
})
