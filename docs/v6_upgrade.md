# To Webpacker v6 from v5

This guide aims to help you migrating to Webpacker 6. If you are using vanilla Webpacker install then hopefully, the upgrade should be really straightforward.

## Main differences with v5

The main goal for Webpacker v6 is to manage the JavaScript in your Rails application with Webpack. This will allow you, for example, to use JavaScript modules, automatic code splitting using multiple entry points, use PostCSS or use [Vue](https://vuejs.org/) or [React](https://reactjs.org/).

You probably don't want to install Webpacker and Webpack if you only need some JavaScript Sprinkles, Sass integration, images and fonts support.

### Default integrations

By default, Webpacker v6 out of the box supports JS and static assets (fonts, images etc.) compilation. Webpacker now detects automatically relevant packages to support more tools.

See [Integrations](https://github.com/rails/webpacker#integrations) for more information.

Why? Because most developers don't need to handle CSS, SASS or another tools with Webpack. [Sprockets](https://github.com/rails/sprockets) is probably enough and we don't want to make things harder.

### Simpler API

Webpacker is still a wrapper around [Webpack](https://webpack.js.org/) to simplify the integration in your Rails application.

But we noticed that the [Webpacker v5 configuration](https://github.com/rails/webpacker/blob/5-x-stable/docs/webpack.md) was a bit confusing mostly because Webpack is a complicated beast to manage.

There are so many different toolchains in JavaScript these days, it would be impossible to create te perfect configuration for everybody. That is also why defaults installers have been removed.

In order to simplify even more the configuration, the custom API to manage the Webpack configuration has been removed.

Now you have a straight access to the Webpack configuration and you can change it very easily with webpack-merge. So now, you can refer to the documentation of the tools you want to install it with Webpack. Here is an example with [Vue](https://github.com/rails/webpacker#other-frameworks).

## How to upgrade to Webpacker v6

1. If your `source_path` is `app/javascript`, rename it to `app/packs`
2. If your `source_entry_path` is `packs`, rename it to `entrypoints`
3. Rename `config/webpack` to `config/webpack_old`
4. Rename `config/webpacker.yml` to `config/webpacker_old.yml`
5. Uninstall the current version of `webpack-dev-server`: `yarn remove webpack-dev-server`
6. Upgrade Webpacker

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

7. If you are using any integrations like `css`, `React` or `TypeScript`. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.

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
  your configuration by merging an object like this. For more details, see docs for
  [Webpack Configuration](https://github.com/rails/webpacker/blob/master/README.md#webpack-configuration)
```js
{
  resolve: {
      extensions: ['.ts', '.tsx']
  }
}
```
