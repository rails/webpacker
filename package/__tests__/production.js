/* test expect, describe, afterAll, beforeEach */

const { resolve } = require('path')
const { chdirTestApp, chdirCwd } = require('../utils/helpers')

chdirTestApp()

describe('Production environment', () => {
  afterAll(chdirCwd)

  describe('webpackConfig', () => {
    beforeEach(() => jest.resetModules())

    test('should use production config and environment', () => {
      process.env.RAILS_ENV = 'production'
      process.env.NODE_ENV = 'production'

      const { webpackConfig } = require('../index')

      expect(webpackConfig.output.path).toEqual(resolve('public', 'packs'))
      expect(webpackConfig.output.publicPath).toEqual('/packs/')

      expect(webpackConfig).toMatchObject({
        devtool: 'source-map',
        stats: 'normal'
      })
    })
  })
})
