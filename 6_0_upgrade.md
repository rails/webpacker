# To webpacker v6 from v5

This guide aims to help you migrating to webpacker 6. If you are using
vanilla webpacker install then hopefully, the upgrade should be really
straightforward.

## Preparation

- Rename `config/webpack` to `config/webpack_old`
- Rename `config/webpacker.yml` to `config/webpacker_old.yml`
- Uninstall the current version of `webpack-dev-server`: `yarn remove webpack-dev-server`
- Upgrade webpacker

  ```ruby
  # Gemfile
  gem 'webpacker', '~> 6.x'
  ```

  ```
  bundle
  ```

  ```bash
  yarn add @rails/webpacker@next
  ```

  ```bash
  bundle exec rails webpacker:install
  ```

- Change `javascript_pack_tag` and `stylesheet_pack_tag` to `javascript_packs_with_chunks_tag` and
  `stylesheet_packs_with_chunks_tag`

- If you are using any integrations like css, react or typescript. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.0

- Copy over any custom webpack config from `config/webpack_old`

  ```js
  // config/webpack/base.js
  const { webpackConfig, merge } = require('@rails/webpacker')
  const customConfig = require('./custom')

  module.exports = merge(webpackConfig, customConfig)
  ```
- Copy over custom browserlist config from `.browserlistrc` if it exists into the `"browserlist"` key in `package.json` and remove `.browserslistrc`.
