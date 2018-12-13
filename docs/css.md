# CSS, Sass and SCSS


Webpacker supports importing CSS, Sass and SCSS files directly into your JavaScript files.


## Import global styles into your JS app

```sass
// app/javascript/hello_react/styles/hello-react.sass

.hello-react
  padding: 20px
  font-size: 12px
```

```js
// React component example
// app/javascript/packs/hello_react.jsx

import React from 'react'
import helloIcon from '../hello_react/images/icon.png'
import '../hello_react/styles/hello-react'

const Hello = props => (
  <div className="hello-react">
    <img src={helloIcon} alt="hello-icon" />
    <p>Hello {props.name}!</p>
  </div>
)
```

## Import scoped styles into your JS app

Stylesheets end with `.module.*` is treated as [CSS Modules](https://github.com/css-modules/css-modules).

```sass
// app/javascript/hello_react/styles/hello-react.module.sass

.helloReact
  padding: 20px
  font-size: 12px
```

```js
// React component example
// app/javascript/packs/hello_react.jsx

import React from 'react'
import helloIcon from '../hello_react/images/icon.png'
import styles from '../hello_react/styles/hello-react'

const Hello = props => (
  <div className={styles.helloReact}>
    <img src={helloIcon} alt="hello-icon" />
    <p>Hello {props.name}!</p>
  </div>
)
```

**Note:** Declared class is referenced as object property in JavaScript.


## Link styles from your Rails views

Under the hood webpack uses
[mini-css-extract-plugin](https://github.com/webpack-contrib/mini-css-extract-plugin) plugin to extract all the referenced styles within your app and compile it into
a separate `[pack_name].css` bundle so that in your view you can use the
`stylesheet_pack_tag` helper.

```erb
<%= stylesheet_pack_tag 'hello_react' %>
```

Webpacker emits css files only if `extract_css` is set to true in webpacker.yml otherwise `stylesheet_pack_tag` returns nil.

## Add bootstrap

You can use Yarn to add bootstrap or any other modules available on npm:

```bash
yarn add bootstrap
```

Import Bootstrap and theme (optional) CSS in your app/javascript/packs/app.js file:

```js
import 'bootstrap/dist/css/bootstrap'
import 'bootstrap/dist/css/bootstrap-theme'
```

Or in your app/javascript/app.sass file:

```sass
// ~ to tell that this is not a relative import

@import '~bootstrap/dist/css/bootstrap'
@import '~bootstrap/dist/css/bootstrap-theme'
```


## Post-Processing CSS

Webpacker out-of-the-box provides CSS post-processing using
[postcss-loader](https://github.com/postcss/postcss-loader)
and the installer sets up a standard `postcss.config.js`
file in your app root with standard plugins.

```js
module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
```

## Using CSS with [vue-loader](https://github.com/vuejs/vue-loader)

Vue templates require loading the stylesheet in your application in
order for CSS to work.  This is in addition to loading the JavaScript
file for the entry point.  Loading the stylesheet will also load the
CSS for any nested components.

```erb
<%= stylesheet_pack_tag 'hello_vue' %>
<%= javascript_pack_tag 'hello_vue' %>
```

## Resolve url loader

Since `Sass/libsass` does not provide url rewriting, all linked assets must be relative to the output. Add the missing url rewriting using the resolve-url-loader. Place it directly after the sass-loader in the loader chain.


```bash
yarn add resolve-url-loader
```

```js
// webpack/environment.js
const { environment } = require('@rails/webpacker')

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
});
```

## Working with TypeScript

In order to get CSS to work with typescript you have two options.
You can either use `require` to bypass typescript special `import`.

```ts
const styles = require('../hello_react/styles/hello-react');
```
You may also use the package [typings-for-css-modules-loader](https://github.com/Jimdo/typings-for-css-modules-loader) instead of `css-loader` to automatically generate typescript `.d.ts` files in order to help resolve any css/scss styles. To do that:

```js
// app/javascript/packs/hello_react.jsx
import * as styles from '../hello_react.styles/hello-react.module.scss';
```

```bash
yarn add --dev typings-for-css-modules-loader
```

```js
// webpack/environment.js
const { environment } = require('@rails/webpacker')

// replace css-loader with typings-for-css-modules-loader
environment.loaders.get('moduleSass').use = environment.loaders.get('moduleSass').use.map((u) => {
  if(u.loader == 'css-loader') {
    return { ...u, loader: 'typings-for-css-modules-loader' };
  } else {
    return u;
  }
});
```
