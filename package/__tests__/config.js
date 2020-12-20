/* global test expect, describe */

const { chdirCwd, chdirTestApp, resetEnv } = require('../utils/helpers')

chdirTestApp()

const config = require('../config')

describe('Config', () => {
  beforeEach(() => jest.resetModules() && resetEnv())
  afterAll(chdirCwd)

  test('public path', () => {
    process.env.RAILS_ENV = 'development'
    const config = require('../config')
    expect(config.publicPath).toEqual('/packs/')
  })

  test('public path with asset host', () => {
    process.env.RAILS_ENV = 'development'
    process.env.WEBPACKER_ASSET_HOST = 'http://foo.com/'
    const config = require('../config')
    expect(config.publicPath).toEqual('http://foo.com/packs/')
  })

  test('should return additional paths as listed in app config, with resolved paths', () => {
    expect(config.additional_paths).toEqual([
      'app/assets',
      '/etc/yarn',
      'some.config.js',
      'app/elm'
    ])
  })
})
