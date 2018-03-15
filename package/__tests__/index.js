/* global test expect, describe */

const { chdirTestApp, chdirCwd } = require('../utils/helpers')

chdirTestApp()

describe('Webpacker', () => {
  beforeEach(() => jest.resetModules())
  afterAll(chdirCwd)

  test('with NODE_ENV set to development', () => {
    process.env.NODE_ENV = 'development'
    const { environment } = require('../index')
    expect(environment.toWebpackConfig()).toMatchObject({
      devServer: {
        host: 'localhost',
        port: 3035
      }
    })
  })

  test('with a non-standard env', () => {
    process.env.NODE_ENV = 'staging'
    process.env.RAILS_ENV = 'staging'
    const { environment } = require('../index')
    expect(environment.toWebpackConfig()).toMatchObject({
      devtool: 'nosources-source-map',
      stats: 'normal'
    })
  })

  test('with a non-standard env extending webpacker\s default', () => {
    process.env.NODE_ENV = 'cucumber'
    process.env.RAILS_ENV = 'cucumber'
    const { environment } = require('../index')
    expect(environment.toWebpackConfig()).toMatchObject({
      devtool: 'cheap-module-source-map'
    })
  })
})
