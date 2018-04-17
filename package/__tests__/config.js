/* global test expect, describe */

const { chdirCwd, chdirTestApp } = require('../utils/helpers')

chdirTestApp()

const config = require('../config')

describe('Config', () => {
  beforeEach(() => jest.resetModules())
  afterAll(chdirCwd)

  test('public path', () => {
    process.env.RAILS_ENV = 'development'
    delete process.env.RAILS_RELATIVE_URL_ROOT
    const config = require('../config')
    expect(config.publicPath).toEqual('/packs/')
  })

  // also tests removal of extra slashes
  test('public path with relative root', () => {
    process.env.RAILS_ENV = 'development'
    process.env.RAILS_RELATIVE_URL_ROOT = '/foo'
    const config = require('../config')
    expect(config.publicPath).toEqual('/foo/packs/')
  })

  test('should return extensions as listed in app config', () => {
    expect(config.extensions).toEqual([
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
    ])
  })
})
