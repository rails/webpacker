const index = require('../index')

describe('index', () => {
  test('exports webpack-merge v5 functions', () => {
    expect(index.merge).toBeInstanceOf(Function)
    expect(index.mergeWithRules).toBeInstanceOf(Function)
    expect(index.mergeWithCustomize).toBeInstanceOf(Function)
  })
})
