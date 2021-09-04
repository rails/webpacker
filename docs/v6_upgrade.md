# Upgrading from Webpacker 5 to 6

There are several substantial changes in Webpacker 6 that you need to manually account for when coming from Webpacker 5. This guide will help you through it.

## Webpacker has become a slimmer wrapper around Webpack

By default, Webpacker 6 is focused on compiling and bundling JavaScript. This pairs with the existing asset pipeline in Rails that's setup to transpile CSS and static images using [Sprockets](https://github.com/rails/sprockets). For most developers, that's the recommended combination. But if you'd like to use Webpacker for CSS and static assets as well, please see [integrations](https://github.com/rails/webpacker#integrations) for more information.

Webpacker used to configure Webpack indirectly, which lead to a [complicated secondary configuration process](https://github.com/rails/webpacker/blob/5-x-stable/docs/webpack.md). This was done in order to provide default configurations for the most popular frameworks, but ended up creating more complexity than it cured. So now Webpacker delegates all configuration directly to Webpack's default configuration setup.

This means you have to configure integration with frameworks yourself, but webpack-merge helps with this. See this example for [Vue](https://github.com/rails/webpacker#other-frameworks).

## How to upgrade to Webpacker 6

1. Move your `app/javascript/packs/application.js` to `app/javascript/application.js`
2. Rename `config/webpack` to `config/webpack_old`
3. Rename `config/webpacker.yml` to `config/webpacker_old.yml`
4. Uninstall the current version of `webpack-dev-server`: `yarn remove webpack-dev-server`
5. Remove .browserslistrc from the root of your Rails app
6. Upgrade the Webpacker Ruby gem and NPM package

Note: [Check the releases page to verify the latest version](https://github.com/rails/webpacker/releases), and make sure to install identical version numbers of webpacker gem and `@rails/webpacker` npm package. (Gems use a period and packages use a dot between the main version number and the beta version.)

Example going to a specific version:

  ```ruby
  # Gemfile
  gem 'webpacker', '6.0.0.rc.5'
  ```

  ```bash
  bundle install
  ```

  ```bash
  yarn add @rails/webpacker@6.0.0-rc.5 --exact
  ```

  ```bash
  bundle exec rails webpacker:install
  ```

7. Update API usage of the view helpers by changing `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` to `javascript_pack_tag` and `stylesheet_pack_tag`. Ensure that your layouts and views will only have **at most one call** to `javascript_pack_tag` or `stylesheet_pack_tag`. You can now pass multiple bundles to these view helper methods. If you fail to changes this, you may experience performance issues, and other bugs related to multiple copies of React, like [issue 2932](https://github.com/rails/webpacker/issues/2932).  If you expose jquery globally with `expose-loader,` by using `import $ from "expose-loader?exposes=$,jQuery!jquery"` in your `app/javascript/application.js`, pass the option `defer: false` to your `javascript_pack_tag`.
8. If you are using any integrations like `css`, `React` or `TypeScript`. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.
9. Copy over any custom webpack config from `config/webpack_old`. Common code previously called 'environment' should be changed to 'base', and import `environment` changed to `webpackConfig`.

  ```js
  // config/webpack/base.js
  const { webpackConfig, merge } = require('@rails/webpacker')
  const customConfig = require('./custom')

  module.exports = merge(webpackConfig, customConfig)
  ```

10. Copy over custom browserlist config from `.browserslistrc` if it exists into the `"browserslist"` key in `package.json` and remove `.browserslistrc`.

11. Remove `babel.config.js` if you never changed it. Be sure to have this config in your `package.json`:
```json
"babel": {
  "presets": [
    "./node_modules/@rails/webpacker/package/babel/preset.js"
  ]
}
```
12. Remove `postcss.config.js` if you don't use `PostCSS`.
13. `extensions` was removed from the `webpacker.yml` file. Move custom extensions to your configuration by merging an object like this. For more details, see docs for [Webpack Configuration](https://github.com/rails/webpacker/blob/master/README.md#webpack-configuration)

```js
{
  resolve: {
    extensions: ['.ts', '.tsx', '.vue', '.css']
  }
}
```
