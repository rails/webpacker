# To webpacker v6 from v5

This guide aims to help you migrating to webpacker 6. If you are using
vanilla webpacker install then hopefully, the upgrade should be really
straightforward.

## Preparation

1. If your `source_path` is `app/javascript`, rename it to `app/packs`
2. If your `source_entry_path` is `packs`, rename it to `entrypoints`
3. Rename `config/webpack` to `config/webpack_old`
4. Rename `config/webpacker.yml` to `config/webpacker_old.yml`
5. Uninstall the current version of `webpack-dev-server`: `yarn remove webpack-dev-server`
6. Upgrade webpacker

  ```ruby
  # Gemfile
  gem 'webpacker', '~> 6.0.0.pre.2'
  ```

  ```bash
  bundle install
  ```

  ```bash
  yarn add @rails/webpacker@next
  ```

  ```bash
  bundle exec rails webpacker:install
  ```

- Change `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` to `javascript_pack_tag` and
  `stylesheet_pack_tag`.

7. If you are using any integrations like `css`, `React` or `TypeScript`. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.0.

8. Copy over any custom webpack config from `config/webpack_old`

- Common code previously called 'environment' changed to 'base' 
- import `environment` changed name to `webpackConfig`.

  ```js
  // config/webpack/base.js
  const { webpackConfig, merge } = require('@rails/webpacker')
  const customConfig = require('./custom')

  module.exports = merge(webpackConfig, customConfig)
  ```

9. Copy over custom browserlist config from `.browserlistrc` if it exists into the `"browserlist"` key in `package.json` and remove `.browserslistrc`.

10. `extensions` was removed from the webpacker.yml file. Move custom extensions to
  your configuration by by merging an object like this. For more details, see docs for 
  [Webpack Configuration](https://github.com/rails/webpacker/blob/master/README.md#webpack-configuration)
```js
{
  resolve: {
      extensions: ['.ts', '.tsx']
  }
}
```
