# webpack


## Configuration

Webpacker gives you a default set of configuration files for test, development and
production environments in `config/webpack/*.js`. You can configure each individual
environment in their respective files or configure them all in the base
`config/webpack/environment.js` file.

By default, you don't need to make any changes to `config/webpack/*.js`
files since it's all standard production-ready configuration. However,
if you do need to customize or add a new loader, this is where you would go.

Here is how you can modify webpack configuration:

You might add separate files to keep your code more organized.
```js
// config/webpack/custom.js
module.exports = {
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery',
      vue: 'vue/dist/vue.js',
      React: 'react',
      ReactDOM: 'react-dom',
      vue_resource: 'vue-resource/dist/vue-resource',
    }
  }
}
```

Then `require` this file in your `config/webpack/environment.js`:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')

// Set nested object prop using path notation
environment.config.set('resolve.extensions', ['.foo', '.bar'])
environment.config.set('output.filename', '[name].js')

// Merge custom config
environment.config.merge(customConfig)

// Merge other options
environment.config.merge({ devtool: 'none' })

// Delete a property
environment.config.delete('output.chunkFilename')

module.exports = environment
```

If you need access to configs within Webpacker's configuration,
you can import them like so:

```js
const { config } = require('@rails/webpacker')

console.log(config.output_path)
console.log(config.source_path)
```

## Loaders

You can add additional loaders beyond the base set that Webpacker provides by
adding it to your environment. We'll use `url-loader` as an example:

```
yarn add url-loader
```

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

const urlLoader = {
  test: /\.png$/,
  use: 'url-loader'
}

// Insert url loader at the end of list
environment.loaders.append('url', urlLoader)

// Insert url loader at the top of list
environment.loaders.prepend('url', urlLoader)

// Insert url loader after/before a given loader
environment.loaders.insert('url', urlLoader, { after: 'style'} )
environment.loaders.insert('url', urlLoader, { before: 'babel'} )

module.exports = environment
```

Finally, add `.png` to the list of extensions in `config/webpacker.yml`. Now if you `import()` any `.png` files inside your JavaScript
they will be processed using `url-loader`. Voila!

You can also modify the loaders that Webpacker pre-configures for you. We'll update
the `babel` loader as an example:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

const babelLoader = environment.loaders.get('babel')
babelLoader.options.cacheDirectory = false

module.exports = environment
```

### Coffeescript 2

Out of the box webpacker supports coffeescript 1,
but here is how you can use Coffeescript 2:

```
yarn add coffeescript@2.0.1
```

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

const babelLoader = environment.loaders.get('babel')

// Replace existing coffee loader with CS2 version
environment.loaders.insert('coffee', {
  test: /\.coffee(\.erb)?$/,
  use:  babelLoader.use.concat(['coffee-loader'])
})

module.exports = environment
```

### React SVG loader

To use react svg loader, you should append svg loader before file loader:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

const babelLoader = environment.loaders.get('babel')

environment.loaders.insert('svg', {
  test: /\.svg$/,
  use: babelLoader.use.concat([
    {
      loader: 'react-svg-loader',
      options: {
        jsx: true // true outputs JSX tags
      }
    }
  ])
}, { before: 'file' })

const fileLoader = environment.loaders.get('file')
fileLoader.exclude = /\.(svg)$/i
```


### Url Loader

Be sure to add the default options from the file loader, as those are applied with the file loader if the size is greater than the `limit`.

```js
// config/webpack/environment.js

const { environment } = require('@rails/webpacker');
const rules = environment.loaders;

const urlFileSizeCutover = 10000;
const urlLoaderOptions = Object.assign({ limit: urlFileSizeCutover }, fileLoader.use[0].options);
const urlLoader = {
  test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
  use: {
    loader: 'url-loader',
    options: urlLoaderOptions,
  },
};

environment.loaders.prepend('url', urlLoader)

// avoid using both file and url loaders
// Note, this list should take into account the config value for static_assets_extensions
environment.loaders.get('file').test = /\.(tiff|ico|svg|eot|otf|ttf|woff|woff2)$/i
```

## Plugins

The process for adding or modifying webpack plugins is the same as the process
for loaders above:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

// Get a pre-configured plugin
const manifestPlugin = environment.plugins.get('Manifest')
manifestPlugin.options.writeToFileEmit = false

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    'window.Tether': 'tether',
    Popper: ['popper.js', 'default'],
    ActionCable: 'actioncable',
    Vue: 'vue',
    VueResource: 'vue-resource',
  })
)

module.exports = environment
```

## Resolved modules

To add new paths to `resolve.modules`, the API is same as loaders and plugins:

```js
const { environment } = require('@rails/webpacker')

// Resolved modules list API - prepend, append, insert
environment.resolvedModules.append('vendor', 'vendor')
```

### Add SplitChunks (Webpack V4+)
Originally, chunks (and modules imported inside them) were connected by a parent-child relationship in the internal webpack graph. The CommonsChunkPlugin was used to avoid duplicated dependencies across them, but further optimizations were not possible.

Since webpack v4, the CommonsChunkPlugin was removed in favor of optimization.splitChunks.

For the full configuration options of SplitChunks, see the [Webpack documentation](https://webpack.js.org/plugins/split-chunks-plugin/).

```js
// config/webpack/environment.js

// Enable the default config
environment.splitChunks()

// or using custom config
environment.splitChunks((config) => Object.assign({}, config, { optimization: { splitChunks: false }}))
```

Then use the `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` helpers to include all the transpiled
packs with the chunks in your view, which creates html tags for all the chunks.

```erb
<%= javascript_packs_with_chunks_tag 'calendar', 'map', 'data-turbolinks-track': 'reload' %>

<script src="/packs/vendor-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/calendar~runtime-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/calendar-1016838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/map~runtime-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
<script src="/packs/map-16838bab065ae1e314.js" data-turbolinks-track="reload"></script>
```

**Important:** Pass all your pack names when using this helper otherwise you will
get duplicated chunks on the page.

```erb
<%# DO %>
<%= javascript_packs_with_chunks_tag 'calendar', 'map' %>

<%# DON'T %>
<%= javascript_packs_with_chunks_tag 'calendar' %>
<%= javascript_packs_with_chunks_tag 'map' %>
```

#### Preloading

Before preload or prefetch your assets, please read [https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content](https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content).

Webpack also provide it's own methods for preload or prefetch [https://medium.com/webpack/link-rel-prefetch-preload-in-webpack-51a52358f84c](https://medium.com/webpack/link-rel-prefetch-preload-in-webpack-51a52358f84c).

You can preload your assets with the `preload_pack_asset` helper if you have Rails >= 5.2.x.

```erb
<%= preload_pack_asset 'fonts/fa-regular-400.woff2' %>
```

**Warning:** You don't want to preload the css, you want to preload the fonts and images inside the css so that fonts, css, and images can all be downloaded in parallel instead of waiting for the browser to parse the css.

More detailed guides available here: [webpack guides](https://webpack.js.org/guides/)

## Webpack Multi-Compiler and Server-Side Rendering
You can export an Array of Object to have both `bin/webpack` and `bin/webpack-dev-server`
use multiple configurations. This is commonly done for React server-side rendering (SSR).

For an example of this, see the configuration within the [`/config/webpack` dir of the React on Rails Example](https://github.com/shakacode/react_on_rails/tree/master/spec/dummy/config/webpack).

Take special care in that you need to make a deep copy of the output from the the basic "client" configuration.

In the example below, you _cannot_ modify the clientConfigObject as that would mutate the "environment" that is global.

```js
  const environment = require('./environment');
  
  // make a deep copy
  const clientConfigObject = environment.toWebpackConfig();
  const serverWebpackConfig = merge({}, clientConfigObject);
  
  // make whatever changes you want for the serverWebpackConfig
  
  // No splitting of chunks for a server bundle
  serverWebpackConfig.optimization = {
    minimize: false,
  };
```
