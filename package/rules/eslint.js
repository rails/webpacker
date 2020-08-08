const { source_path: sourcePath } = require('../config')

module.exports = {
  test: /\.(js|mjs|jsx|ts|tsx)$/,
  enforce: 'pre',
  use: [
    {
      options: {
        cache: true,
        eslintPath: require.resolve('eslint'),
        resolvePluginsRelativeTo: __dirname
      },
      loader: require.resolve('eslint-loader')
    }
  ],
  include: sourcePath
}
