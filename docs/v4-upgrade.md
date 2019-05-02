# Webpacker Upgrade Guide


To update a Webpacker v3.5 app to v4, follow these steps:

1. Update the `webpacker` gem and the `@rails/webpacker` package to v4. This will upgrade Webpack itself from 3.x to 4.x, make sure you're aware of [any deprecations which might effect you](https://webpack.js.org/migrate/4/). Also make sure any other packages you depend on support Webpack 4 and don't require any changes, e.g. if you explicitly include `webpack` you need to upgrade it to 4.x, and if you use `webpack-dev-server` you need to upgrade it to 3.x.

2. Browser support definitions have been moved from [`.browserslistrc`](../lib/install/config/.browserslistrc) to `/`.

3. Merge any differences between [`config/webpacker.yml`](../lib/install/config/webpacker.yml) and your `config/webpacker.yml`.

4. Webpacker v4 upgrades Babel to [v7](https://babeljs.io/docs/en/v7-migration), see also [the release blog post](https://babeljs.io/blog/2018/08/27/7.0.0). Many packages were moved to the `@babel/` namespace, any babel plugins you have will need to be updated. It may be worth checking out [babel-upgrade](https://github.com/babel/babel-upgrade) if you have problems. ([#1564](https://github.com/rails/webpacker/pull/1564))

5. `.babelrc` should be replaced with `babel.config.js` and `.postcssrc.yml` should be replaced with `postcss.config.js` ([#1822](https://github.com/rails/webpacker/pull/1822)). If you never changed these files from their defaults, the versions of [babel.config.js](../lib/install/config/babel.config.js) and [postcss.config.js](../lib/install/config/postcss.config.js) in the webpacker repository should be usable.

6. Due to the change in [#1625](https://github.com/rails/webpacker/pull/1625), you'll want to make sure that `extract_css` is set to true for the `default` environment in `webpacker.yml` if you want to have Webpacker supply your CSS.

## SplitChunks Configuration

If you used the `CommonsChunkPlugin` you'll need to upgrade to using the new `splitChunks`.

Originally, chunks (and modules imported inside them) were connected by a parent-child relationship in the internal Webpack graph. The `CommonsChunkPlugin` was used to avoid duplicated dependencies across them, but further optimizations were not possible.

In Webpack v4, the `CommonsChunkPlugin` was removed in favor of `optimization.splitChunks`.

For the full configuration options of `splitChunks`, see the [Webpack documentation](https://webpack.js.org/plugins/split-chunks-plugin/).

```js
// config/webpack/environment.js
const WebpackAssetsManifest = require('webpack-assets-manifest');

// Enable the default config
environment.splitChunks()

// or using custom config
environment.splitChunks((config) => Object.assign({}, config, { optimization: { splitChunks: false }}))
```

Then use the `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` helpers to include all the transpiled
packs with the chunks in your view, which creates html tags for all the chunks.

```erb
<%= javascript_packs_with_chunks_tag 'calendar', 'map', 'data-turbolinks-track': 'reload' %>

<!-- Creates the following: -->
<script src="/packs/vendor-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/calendar~runtime-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/calendar-1016838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/map~runtime-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/map-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
```

**Important:** Pass all your pack names to the helper otherwise you will get duplicated chunks on the page.

```erb
<%# DO %>
<%= javascript_packs_with_chunks_tag 'calendar', 'map' %>

<%# DON'T %>
<%= javascript_packs_with_chunks_tag 'calendar' %>
<%= javascript_packs_with_chunks_tag 'map' %>
```

## Package-Specific Notes

- If you're using React, you need to add `"@babel/preset-react"`, to the list of `presets` in your babel config.
- If you're using Vue Loader, you'll need to upgrade to [v15](https://vue-loader.vuejs.org/migrating.html) for Webpack 4.
- To see what Webpacker generates for a given framework with v4, you may want to re-run `bundle exec rake webpacker:install:FRAMEWORK` and let it override the files for your given JavaScript framework, and then compare them to see what changes you'll need to make.

## Excluding node_modules From Being Transpiled By Babel-Loader

One change to take into consideration, is that Webpacker 4 transpiles the
`node_modules` folder with the `babel-loader`. This folder used to be ignored by
Webpacker 3. The new behavior helps in case some library contains ES6 code, but in
some cases it can lead to issues. To avoid running `babel-loader` in the
`node_modules` folder, replicating the same behavior as Webpacker 3, the
following code can be added to `config/webpack/environment.js`:

```javascript
environment.loaders.delete('nodeModules')
```

Alternatively, in order to skip only a specific library in the `node_modules`
folder, this code can be added:

```javascript
const nodeModulesLoader = environment.loaders.get('nodeModules')
if (!Array.isArray(nodeModulesLoader.exclude)) {
  nodeModulesLoader.exclude = (nodeModulesLoader.exclude == null)
    ? []
    : [nodeModulesLoader.exclude]
}
nodeModulesLoader.exclude.push(/some-library/) // replace `some-library` with
                                               // the actual path to exclude
```

## Source Maps Enabled By Default

Source maps are now enabled in production to make debugging in production easier. Enabling source maps doesn't have drawbacks for most of the applications since maps are compressed by default and aren't loaded by browsers unless Dev Tools are opened.

If you want to keep the old behavior source maps can be disabled in any environment configuration, e.g:

```js
// config/webpack/production.js

const environment = require('./environment')
environment.config.merge({ devtool: false })

module.exports = environment.toWebpackConfig()
```

## Namespaces

The compiled packs in the public directory are now stored under namespaces:

- JavaScripts are stored under `js`
- Stylesheets are stored under `css`
- Other resources are stored under `media`

```rb
# Before
"runtime~hello_react" => "/packs/runtime~hello_react-da2baf7fd07b0e8b6d17.js"

# After
"runtime~hello_react" => "/packs/js/runtime~hello_react-da2baf7fd07b0e8b6d17.js"
```

## Upgrading projects with custom Webpack setups that use only the view helpers
The default value for `extract_css` is **false** in `config/webpack.yml`. Custom webpack builds that extract the CSS such as often used with [React on Rails](https://github.com/shakacode/react_on_rails) should set this value to true or else no CSS link tags are generated.

  ```yml
  default: &default
     # other stuff
     extract_css: true
     # by default, extract and emit a css file. The default is false
  ```

## Example Upgrades

This is what an upgrade to Webpacker 4 looked like for existing Rails apps (please contribute yours!):

- https://github.com/connorshea/ContinueFromCheckpoint/pull/77
