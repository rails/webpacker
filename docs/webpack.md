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

// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')

// Set nested object prop using path notation
environment.config.set('resolve.extensions', ['.foo', '.bar'])
environment.config.set('output.filename', '[name].js')

// Merge custom config
environment.config.merge(customConfig)

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
adding it to your environment. We'll use `json-loader` as an example:

```
yarn add json-loader
```

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

environment.loaders.append('json', {
  test: /\.json$/,
  use: 'json-loader'
})

// Insert json loader at the top of list
environment.loaders.prepend('json', jsonLoader)

// Insert json loader after/before a given loader
environment.loaders.insert('json', jsonLoader, { after: 'style'} )
environment.loaders.insert('json', jsonLoader, { before: 'babel'} )

module.exports = environment
```

Finally add `.json` to the list of extensions in `config/webpacker.yml`. Now if you `import()` any `.json` files inside your JavaScript
they will be processed using `json-loader`. Voila!

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
}, { after: 'file' })

const fileLoader = environment.loaders.get('file')
fileLoader.exclude = /\.(svg)$/i
```


### Url Loader

```js
// config/webpack/loaders/url.js

module.exports = {
  test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
  use: [{
    loader: 'url-loader',
    options: {
      limit: 10000,
      name: '[name]-[hash].[ext]'
    }
  }]
}

// config/webpack/environment.js

const { environment } = require('@rails/webpacker')

environment.loaders.prepend('url', url)
```

### Overriding Loader Options in webpack 3+ (for CSS Modules etc.)

In webpack 3+, if you'd like to specify additional or different options for a loader, edit `config/webpack/environment.js` and provide an options object to override. This is similar to the technique shown above, but the following example shows specifically how to apply CSS Modules, which is what you may be looking for:

```javascript
const { environment } = require('@rails/webpacker')
const merge = require('webpack-merge')

const myCssLoaderOptions = {
  modules: true,
  sourceMap: true,
  localIdentName: '[name]__[local]___[hash:base64:5]'
}

const CSSLoader = environment.loaders.get('sass').use.find(el => el.loader === 'css-loader')

CSSLoader.options = merge(CSSLoader.options, myCssLoaderOptions)

module.exports = environment
```

See [issue #756](https://github.com/rails/webpacker/issues/756#issuecomment-327148547) for additional discussion of this.

For this to work, don't forget to use the `stylesheet_pack_tag`, for example:

```
<%= stylesheet_pack_tag 'YOUR_PACK_NAME_HERE' %>
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
manifestPlugin.opts.writeToFileEmit = false

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
```

## Resolved modules

To add new paths to `resolve.modules`, the API is same as loaders and plugins:

```js
const { environment } = require('@rails/webpacker')

// Resolved modules list API - prepend, append, insert
environment.resolvedModules.append('vendor', 'vendor')
```

### Split common chunks

CommonsChunkPlugin was used to avoid duplicated dependencies across them, but further optimizations were not possible. Since webpack v4, the CommonsChunkPlugin was removed in favor of optimization.splitChunks: https://webpack.js.org/plugins/split-chunks-plugin/

Enable it from your `config/webpack/environment.js`:

```js
// environment.js
const { environment } = require('@rails/webpacker')
// Enable with default config
environment.splitChunks()
// Disable vendors chunks
environment.splitChunks((config) => Object.assign({}, config, { optimization: { splitChunks: false }})
// Disable runtime chunk
environment.splitChunks((config) => Object.assign({}, config, { optimization: { runtimeChunk: false }}))
```

Now, add vendor chunk to your `layouts/application.html.erb`:

```erb
<%# To include vendor chunk in your layout file %>
<%= javascript_pack_tag 'vendors' %>
```

And runtime chunk to individual views where you have included your pack:

```erb
<%# To include runtime chunks in your view for application pack %>
<%= javascript_pack_tag 'runtime~application '%>
<%= javascript_pack_tag 'application '%>
```

More detailed guides available here: [webpack guides](https://webpack.js.org/guides/)
