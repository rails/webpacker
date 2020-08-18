const validateBoolOption = (name, value, defaultValue) => {
  if (typeof value === 'undefined') {
    return defaultValue
  }

  if (typeof value !== 'boolean') {
    throw new Error(`Preset webpacker: '${name}' option must be a boolean.`)
  }

  return value
}

module.exports = function config(api, opts) {
  const validEnv = ['development', 'test', 'production']
  const currentEnv = api.env()
  const isDevelopmentEnv = api.env('development')
  const isProductionEnv = api.env('production')
  const isTestEnv = api.env('test')

  if (!validEnv.includes(currentEnv)) {
    throw new Error(
      `Please specify a valid NODE_ENV or BABEL_ENV environment variable. Valid values are "development", "test", and "production". Instead, received: "${JSON.stringify(currentEnv)}".`
    )
  }

  const isTypeScriptEnabled = validateBoolOption(
    'typescript',
    opts.typescript,
    false
  )

  const isReactEnabled = validateBoolOption(
    'react',
    opts.react,
    false
  )

  return {
    presets: [
      isTestEnv && [
        '@babel/preset-env',
        {
          targets: {
            node: 'current'
          }
        }
      ],
      (isProductionEnv || isDevelopmentEnv) && [
        '@babel/preset-env',
        {
          useBuiltIns: 'entry',
          corejs: 3,
          modules: false,
          bugfixes: true,
          loose: true,
          exclude: ['transform-typeof-symbol']
        }
      ],
      isReactEnabled && [
        '@babel/preset-react',
        {
          development: isDevelopmentEnv || isTestEnv,
          useBuiltIns: true
        }
      ],
      isTypeScriptEnabled && ['@babel/preset-typescript', { allExtensions: true, isTSX: true }]
    ].filter(Boolean),
    plugins: [
      'babel-plugin-macros',
      [
        '@babel/plugin-proposal-class-properties',
        {
          loose: true
        }
      ],
      [
        '@babel/plugin-transform-runtime',
        {
          helpers: false
        }
      ],
      isReactEnabled && isProductionEnv && [
        'babel-plugin-transform-react-remove-prop-types',
        {
          removeImport: true
        }
      ]
    ].filter(Boolean)
  }
}
