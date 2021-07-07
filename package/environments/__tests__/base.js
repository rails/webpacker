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

  describe('config', () => {
    test('should return entry', () => {
      expect(baseConfig.entry.application).toEqual(
        resolve('app', 'packs', 'entrypoints', 'application.js')
      )
    })

    test('should return multi file entry points', () => {
      expect(baseConfig.entry.multi_entry.sort()).toEqual([
        resolve('app', 'packs', 'entrypoints', 'multi_entry.css'),
        resolve('app', 'packs', 'entrypoints', 'multi_entry.js')
      ])
    })

    test('should return output', () => {
      expect(baseConfig.output.filename).toEqual('js/[name].js')
      expect(baseConfig.output.chunkFilename).toEqual(
        'js/[name].chunk.js'
      )
    })

    test('should return default loader rules for each file in config/loaders', () => {
      const defaultRules = Object.keys(rules)
      const configRules = baseConfig.module.rules

      expect(defaultRules.length).toEqual(3)
      expect(configRules.length).toEqual(3)
    })

    test('should return default plugins', () => {
      expect(baseConfig.plugins.length).toEqual(2)
    })

    test('should return default resolveLoader', () => {
      expect(baseConfig.resolveLoader.modules).toEqual(['node_modules'])
    })

    test('should return default resolve.modules with additions', () => {
      expect(baseConfig.resolve.modules).toEqual([
        resolve('app', 'packs'),
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
