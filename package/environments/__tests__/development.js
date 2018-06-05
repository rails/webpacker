/* Globalx test expect, describe, afterAll, beforeEach */

const RAILS_ENV = process.env.RAILS_ENV
const NODE_ENV = process.env.NODE_ENV
process.env.RAILS_ENV = 'development'
process.env.NODE_ENV = 'development'

// environment.js expects to find config/webpacker.yml and resolved modules from
// the root of a Rails project
const { chdirTestApp, chdirCwd } = require('../../utils/helpers')

chdirTestApp()

const { resolve } = require('path')
const rules = require('../../rules')
const { ConfigList } = require('../../config_types')
const Environment = require('../development')

describe('Development Environment', () => {
  afterAll(() => {
    chdirCwd()
  })

  let environment

  describe('toWebpackConfig', () => {
    beforeEach(() => {
    })

    test('should return default plugins, without Compression or CSSOptimization', () => {
      environment = new Environment()
      const config = environment.toWebpackConfig()
      expect(config.plugins.map((p) => p.constructor.name)).toEqual(["EnvironmentPlugin",
                                                                     "CaseSensitivePathsPlugin",
                                                                     "MiniCssExtractPlugin",
                                                                     "WebpackAssetsManifest"])
    })
  })
})

process.env.RAILS_ENV = RAILS_ENV
process.env.NODE_ENV = NODE_ENV
