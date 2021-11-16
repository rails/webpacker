# Upgrading from Webpacker 5 to 6

There are several substantial changes in Webpacker 6 that you need to manually account for when coming from Webpacker 5. This guide will help you through it.

## Webpacker has become a slimmer wrapper around Webpack

By default, Webpacker 6 is focused on compiling and bundling JavaScript. This pairs with the existing asset pipeline in Rails that's setup to transpile CSS and static images using [Sprockets](https://github.com/rails/sprockets). For most developers, that's the recommended combination. But if you'd like to use Webpacker for CSS and static assets as well, please see [integrations](https://github.com/rails/webpacker#integrations) for more information.

Webpacker used to configure Webpack indirectly, which lead to a [complicated secondary configuration process](https://github.com/rails/webpacker/blob/5-x-stable/docs/webpack.md). This was done in order to provide default configurations for the most popular frameworks, but ended up creating more complexity than it cured. So now Webpacker delegates all configuration directly to Webpack's default configuration setup.

This means you have to configure integration with frameworks yourself, but webpack-merge helps with this. See this example for [Vue](https://github.com/rails/webpacker#other-frameworks) and scroll to the bottom for [more examples](#examples-of-v5-to-v6).

## How to upgrade to Webpacker v6 from v5

1. Consider changing from the v5 default for `source_entry_path`.
  ```yml
    source_path: app/javascript
    source_entry_path: packs
  ```
  consider changing to the v6 default:
  ```yml
    source_path: app/javascript
    source_entry_path: /
  ```
  Then consider moving your `app/javascript/packs/*` (including `application.js`) to `app/javascript/` and updating the configuration file. 
  
  Note, moving your files is optional, as you can stil keep your entries in a separate directory, called something like `packs`, or `entries`. This directory is defined within the source_path.
  
2. **Ensure no nested directories in your `source_entry_path`.** Check if you had any entry point files in child directories of your `source_entry_path`. Files for entry points in child directories are not supported by rails/webpacker v6. Move those files to the top level, adjusting any imports in those files.
  
  The new v6 configuration does not allow nesting, so as to allow placing the entry points at in the root directory of JavaScript. You can find this change [here](https://github.com/rails/webpacker/commit/5de0fbc1e16d3db0c93202fb39f5b4d80582c682#diff-7af8667a3e36201db57c02b68dd8651883d7bfc00dc9653661be11cd31feeccdL19).

3. Rename `config/webpack` to `config/webpack_old`

4. Rename `config/webpacker.yml` to `config/webpacker_old.yml`

5. Update `webpack-dev-server` to the current version, greater than 4.2, updating `package.json`.

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

7. Update API usage of the view helpers by changing `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` to `javascript_pack_tag` and `stylesheet_pack_tag`. Ensure that your layouts and views will only have **at most one call** to `javascript_pack_tag` and **at most one call** to `stylesheet_pack_tag`. You can now pass multiple bundles to these view helper methods. If you fail to changes this, you may experience performance issues, and other bugs related to multiple copies of React, like [issue 2932](https://github.com/rails/webpacker/issues/2932).  If you expose jquery globally with `expose-loader,` by using `import $ from "expose-loader?exposes=$,jQuery!jquery"` in your `app/javascript/application.js`, pass the option `defer: false` to your `javascript_pack_tag`.

8. If you are using any integrations like `css`, `postcss`, `React` or `TypeScript`. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.

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

12. `extensions` was removed from the `webpacker.yml` file. Move custom extensions to your configuration by merging an object like this. For more details, see docs for [Webpack Configuration](https://github.com/rails/webpacker/blob/master/README.md#webpack-configuration)

  ```js
  {
    resolve: {
      extensions: ['.ts', '.tsx', '.vue', '.css']
    }
  }
  ```

13. Some dependencies were removed in [PR 3056](https://github.com/rails/webpacker/pull/3056). If you see the error: `Error: Cannot find module 'babel-plugin-macros'`, or similar, then you need to `yarn add <dependency>` where <dependency> might include: `babel-plugin-macros`, `case-sensitive-paths-webpack-plugin`, `core-js`, `regenerator-runtime`. Or you might want to remove your dependency on those.

14. If `bin/yarn` does not exist, create an executable [yarn](https://github.com/rails/webpacker/blob/master/lib/install/bin/yarn) file in your `/bin` directory.

15. Remove overlapping dependencies from your `package.json` and rails/webpacker's `package.json`. For example, don't include `webpack` directly as that's a dependency of rails/webpacker.

16. Review the new default's changes to `webpacker.yml` and `config/webpack`. Consider each suggested change carefully, especially the change to have your `source_entry_path` be at the top level of your `source_path`.

17. Make sure that you can run `bin/webpack` without errors.

18. Try running `RAILS_ENV=production bin/rails assets:precompile`. If all goes well, don't forget to clean the generated assets with `bin/rails assets:clobber`.

19. Run `yarn add webpack-dev-server` if those are not already in your dev dependencies. Make sure you're using v4+.

20. Try your app!

## Examples of v5 to v6

1. [React on Rails Project with HMR and SSR](https://github.com/shakacode/react_on_rails_tutorial_with_ssr_and_hmr_fast_refresh/compare/webpacker-5.x...master)
2. [Vue and Sass Example](https://github.com/guillaumebriday/upgrade-webpacker-5-to-6)
