/* global test expect, describe, afterAll, beforeEach */

// environment.js expects to find config/webpacker.yml and resolved modules from
// the root of a Rails project

const { chdirTestApp, chdirCwd } = require('../../utils/helpers')

chdirTestApp()

const { resolve } = require('path')
const rules = require('../../rules')
const baseConfig = require('../base')

describe('Base config', () => {
  afterAll(chdirCwd)

  describe('toWebpackConfig', () => {
    test('should return entry', () => {
      expect(baseConfig.entry.application).toEqual(
        resolve('app', 'javascript', 'packs', 'application.js')
      )
    })

    test('should return multi file entry points', () => {
      expect(baseConfig.entry.multi_entry.sort()).toEqual([
        resolve('app', 'javascript', 'packs', 'multi_entry.css'),
        resolve('app', 'javascript', 'packs', 'multi_entry.js')
      ])
    })

    test('should return output', () => {
      expect(baseConfig.output.filename).toEqual('js/[name]-[contenthash].js')
      expect(baseConfig.output.chunkFilename).toEqual(
        'js/[name]-[contenthash].chunk.js'
      )
    })

    test('should return default loader rules for each file in config/loaders', () => {
      const defaultRules = Object.keys(rules)
      const configRules = baseConfig.module.rules

      expect(defaultRules.length).toEqual(1)
      expect(configRules.length).toEqual(1)
    })

    test('should return cache path for nodeModules rule', () => {
      const nodeModulesRule = require('../../rules/node_modules')
      const nodeModulesLoader = nodeModulesRule.use.find(
        (rule) => rule.loader === 'babel-loader'
      )

      expect(nodeModulesLoader.options.cacheDirectory).toBeTruthy()
    })

    test('should return cache path for babel-loader rule', () => {
      const babelLoader = rules.babel.use.find(
        (rule) => rule.loader === 'babel-loader'
      )

      expect(babelLoader.options.cacheDirectory).toBeTruthy()
    })

    test('should return default plugins', () => {
      expect(baseConfig.plugins.length).toEqual(4)
    })

    test('should return default resolveLoader', () => {
      expect(baseConfig.resolveLoader.modules).toEqual(['node_modules'])
    })

    test('should return default resolve.modules with additions', () => {
      expect(baseConfig.resolve.modules).toEqual([
        resolve('app', 'javascript'),
        resolve('app/assets'),
        resolve('/etc/yarn'),
        resolve('some.config.js'),
        resolve('app/elm'),
        'node_modules'
      ])
    })

    test('returns plugins property as Array', () => {
      expect(baseConfig.plugins).toBeInstanceOf(Array)
    })
  })
})
