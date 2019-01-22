To update a Webpacker v3.5 app to v4, follow these steps:

1. Update the `webpacker` gem and the `@rails/webpacker` package to v4. This will upgrade webpack itself from 3.x to 4.x, make sure you're aware of [any deprecations which might effect you](https://webpack.js.org/migrate/4/). Also make sure any other packages you depend on support webpack 4 and don't require any changes, e.g. if you explicitly include `webpack` you need to upgrade it to 4.x, and if you use `webpack-dev-server` you need to upgrade it to 3.x.
1. Browser support definitions have been moved to [`.browserslistrc`](../lib/install/config/.browserslistrc) to `/`.
1. Merge any differences between [`config/webpacker.yml`](../lib/install/config/webpacker.yml) and your `config/webpacker.yml`.
1. Webpacker v4 upgrades Babel to [v7](https://babeljs.io/docs/en/v7-migration), see also [the release blog post](https://babeljs.io/blog/2018/08/27/7.0.0). Many packages were moved to the `@babel/` namespace, any babel plugins you have will need to be updated. It may be worth checking out [babel-upgrade](https://github.com/babel/babel-upgrade) if you have problems. ([#1564](https://github.com/rails/webpacker/pull/1564))
1. `.babelrc` should be replaced with `babel.config.js` and `.postcssrc.yml` should be replaced with `postcss.config.js` ([#1822](https://github.com/rails/webpacker/pull/1822)). If you never changed these files from their defaults, the versions of [babel.config.js](../lib/install/config/babel.config.js) and [postcss.config.js](../lib/install/config/postcss.config.js) in the webpacker repository should be usable.
1. Due to the change in [#1625](https://github.com/rails/webpacker/pull/1625), you'll want to make sure that `extract_css` is set to true for the `default` environment in `webpacker.yml` if you want to have Webpacker supply your CSS.

If you're using split chunks, pay special attention to the [`CommonsChunkPlugin` removal in Webpack 4](https://webpack.js.org/migrate/4/#commonschunkplugin) ([This gist](https://gist.github.com/sokra/1522d586b8e5c0f5072d7565c2bee693) may also be useful for upgrading).

Where previously you'd have code like this:

```js
environment.plugins.append(
  'CommonsChunk',
   new CommonsChunkPlugin({
      name: 'something-vendor',
      chunks: ['something'],
      minChunks(module) {
        return module.context && module.context.includes('node_modules');
      },
  }),
);
```

It would now be more like:

```js
environment.config.optimization.splitChunks = {
  cacheGroups: {
    vendor: {
      name: 'something-vendor',
      chunks: chunk => chunk.name === 'something',
      reuseExistingChunk: true,
      priority: 1,
      test: /[\\/]node_modules[\\/]/,
      minChunks: 1,
      minSize: 0,
    },
  },
};
```

When using the new Webpack 4 `splitChunks` API, also consider using the `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` helpers, which create HTML tags for the packs and all its dependent chunks.

Package-specific notes:

- If you're using React, you need to add `"@babel/preset-react"`, to the list of `presets` in your babel config.
- If you're using Vue Loader, you'll need to upgrade to [v15](https://vue-loader.vuejs.org/migrating.html) for webpack 4.
- To see what webpacker generates for a given framework with v4, you may want to re-run `bundle exec rake webpacker:install:FRAMEWORK` and let it override the files for your given JavaScript framework, and then compare them to see what changes you'll need to make.

This is what an upgrade to Webpacker 4 looked like for existing Rails apps (please contribute yours!):

- https://github.com/connorshea/ContinueFromCheckpoint/pull/77
