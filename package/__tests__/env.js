/* global test expect, describe */

const { chdirTestApp, chdirCwd } = require('../utils/helpers')

chdirTestApp()

describe('Env', () => {
  beforeEach(() => jest.resetModules())
  afterAll(chdirCwd)

  test('with NODE_ENV set to development', () => {
    process.env.NODE_ENV = 'development'
    expect(require('../env')).toEqual('development')
  })

  test('with undefined NODE_ENV and RAILS_ENV set to development', () => {
    delete process.env.NODE_ENV
    process.env.RAILS_ENV = 'development'
    expect(require('../env')).toEqual('development')
  })

  test('with a non-standard environment', () => {
    process.env.NODE_ENV = 'foo'
    process.env.RAILS_ENV = 'foo'
    expect(require('../env')).toEqual('production')
    delete process.env.RAILS_ENV
  })
})
