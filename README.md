# Webpacker

![travis-ci status](https://api.travis-ci.org/rails/webpacker.svg?branch=master)
[![node.js](https://img.shields.io/badge/node-%3E%3D%206.0.0-brightgreen.svg)](https://nodejs.org/en/)
[![Gem](https://img.shields.io/gem/v/webpacker.svg)](https://github.com/rails/webpacker)

Webpacker makes it easy to use the JavaScript pre-processor and bundler
[Webpack 3.x.x+](https://webpack.js.org/)
to manage application-like JavaScript in Rails. It coexists with the asset pipeline,
as the primary purpose for Webpack is app-like JavaScript, not images, CSS, or
even JavaScript Sprinkles (that all continues to live in app/assets).

However, it is possible to use Webpacker for CSS, images and fonts assets as well,
in which case you may not even need the asset pipeline. This is mostly relevant when exclusively using component-based JavaScript frameworks.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Prerequisites](#prerequisites)
- [Features](#features)
- [Installation](#installation)
- [Integrations](#integrations)
  - [React](#react)
  - [Angular with TypeScript](#angular-with-typescript)
  - [Vue](#vue)
    - [Using Rails helpers in .vue files](#using-rails-helpers-in-vue-files)
  - [Elm](#elm)
- [Binstubs](#binstubs)
- [Developing with Webpacker](#developing-with-webpacker)
- [Configuration](#configuration)
  - [Webpack](#webpack-1)
  - [Loaders](#loaders)
  - [Paths](#paths)
    - [Resolved Paths](#resolved-paths)
  - [Babel](#babel)
  - [Post-Processing CSS](#post-processing-css)
  - [CDN](#cdn)
  - [HTTPS in development](#https-in-development)
  - [Hot module replacement](#hot-module-replacement)
- [Linking Styles, Images and Fonts](#linking-styles-images-and-fonts)
  - [Within your JS app](#within-your-js-app)
  - [Inside views](#inside-views)
  - [From node modules folder](#from-node-modules-folder)
- [How-tos](#how-tos)
  - [App structure](#app-structure)
    - [Namespacing](#namespacing)
  - [Pass data from view](#pass-data-from-view)
    - [React](#react-1)
    - [Vue](#vue-1)
  - [Add common chunks](#add-common-chunks)
  - [Module import() vs require()](#module-import-vs-require)
  - [Add a new npm module](#add-a-new-npm-module)
  - [Add bootstrap](#add-bootstrap)
  - [Use Typescript with React](#use-typescript-with-react)
  - [Use HTML templates with Typescript and Angular](#use-html-templates-with-typescript-and-angular)
  - [CSS modules](#css-modules)
  - [CSS-Next](#css-next)
  - [Ignoring swap files](#ignoring-swap-files)
  - [Link sprocket assets](#link-sprocket-assets)
    - [Using helpers](#using-helpers)
    - [Using babel module resolver](#using-babel-module-resolver)
  - [Environment variables](#environment-variables)
- [Extending](#extending)
- [Deployment](#deployment)
  - [Heroku](#heroku)
- [Testing](#testing)
  - [Lazy compilation](#lazy-compilation)
    - [Caching](#caching)
- [Troubleshooting](#troubleshooting)
    - [ENOENT: no such file or directory - node-sass](#enoent-no-such-file-or-directory---node-sass)
    - [Can't find hello_react.js in manifest.json](#cant-find-hello_reactjs-in-manifestjson)
    - [Error: listen EADDRINUSE 0.0.0.0:8080](#error-listen-eaddrinuse-00008080)
    - [throw er; // Unhandled 'error' event](#throw-er--unhandled-error-event)
    - [webpack or webpack-dev-server not found](#webpack-or-webpack-dev-server-not-found)
    - [Running Webpack on Windows](#running-webpack-on-windows)
- [Wishlist](#wishlist)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Prerequisites

* Ruby 2.2+
* Rails 4.2+
* Node.js 6.0.0+
* Yarn 0.20.1+


## Features

* [Webpack 3.x.x](https://webpack.js.org/)
* ES6 with [babel](https://babeljs.io/)
* Automatic code splitting using multiple entry points
* Stylesheets - SASS and CSS
* Images and fonts
* PostCSS - Auto-Prefixer
* Asset compression, source-maps, and minification
* CDN support
* React, Angular, Elm and Vue support out-of-the-box
* Rails view helpers
* Extensible and configurable


## Installation

You can either add Webpacker during setup of a new Rails 5.1+ application
using new `--webpack` option:

```bash
# Available Rails 5.1+
rails new myapp --webpack
```

Or add it to your `Gemfile`, run bundle and `./bin/rails webpacker:install` or
`bundle exec rake webpacker:install` (on rails version < 5.0):

```ruby
# Gemfile
gem 'webpacker', '~> 2.0'

# OR if you prefer to use master
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'
```

**Note:** Use `rake` instead of `rails` if you are using webpacker
with rails version < 5.0


## Integrations

Webpacker ships with basic out-of-the-box integration for React, Angular, Vue and Elm.
You can see a list of available commands/tasks by running:

```bash
# Within rails app
./bin/rails webpacker
```

or in rails version < 5.0

```bash
# Within rails app
./bin/rake webpacker
```


### React

To use Webpacker with [React](https://facebook.github.io/react/), create a
new Rails 5.1+ app using `--webpack=react` option:

```bash
# Rails 5.1+
rails new myapp --webpack=react
```

(or run `./bin/rails webpacker:install:react` in a existing Rails app already
setup with webpacker).

The installer will add all relevant dependencies using yarn, any changes
to the configuration files and an example React component to your
project in `app/javascript/packs` so that you can experiment with React right away.


### Angular with TypeScript

To use Webpacker with [Angular](https://angularjs.org/), create a
new Rails 5.1+ app using `--webpack=angular` option:

```bash
# Rails 5.1+
rails new myapp --webpack=angular
```

(or run `./bin/rails webpacker:install:angular` on a Rails app already
setup with webpacker).

The installer will add TypeScript and Angular core libraries using yarn plus
any changes to the configuration files. An example component is written in
TypeScript will also be added to your project in `app/javascript` so that
you can experiment with Angular right away.


### Vue

To use Webpacker with [Vue](https://vuejs.org/), create a
new Rails 5.1+ app using `--webpack=vue` option:

```bash
# Rails 5.1+
rails new myapp --webpack=vue
```
(or run `./bin/rails webpacker:install:vue` on a Rails app already setup with webpacker).

The installer will add Vue and required libraries using yarn plus
any changes to the configuration files. An example component will
also be added to your project in `app/javascript` so that you can
experiment Vue right away.

### Elm

To use Webpacker with [Elm](http://elm-lang.org), create a
new Rails 5.1+ app using `--webpack=elm` option:

```
# Rails 5.1+
rails new myapp --webpack=elm
```

(or run `./bin/rails webpacker:install:elm` on a Rails app already setup with webpacker).

The Elm library and core packages will be added via Yarn and Elm itself.
An example `Main.elm` app will also be added to your project in `app/javascript`
so that you can experiment with Elm right away.


## Binstubs

Webpacker ships with two binstubs: `./bin/webpack` and `./bin/webpack-dev-server`.
Both are thin wrappers around the standard `webpack.js` and `webpack-dev-server.js`
executable to ensure that the right configuration file and environment variables
are loaded depending on your environment.


## Developing with Webpacker

In development, Webpacker compiles on demand rather than upfront by default. This
happens when you refer to any of the pack assets using the Webpacker helper methods.
That means you don't have to run any separate process. Compilation errors are logged
to the standard Rails log.

If you want to use live code reloading, or you have enough JavaScript that on-demand compilation is too slow, you'll need to run `./bin/webpack-dev-server`
in a separate terminal from `./bin/rails server`. This process will watch for changes
in the `app/javascript/packs/*.js` files and automatically reload the browser to match.

Once you start this development server, Webpacker will automatically start proxying all
webpack asset requests to this server. When you stop the server, it'll revert to
on-demand compilation again.

You can also pass CLI options supported by [webpack-dev-server](https://webpack.js.org/configuration/dev-server/). Please note that inline options will always take
precedence over the ones already set in the configuration file.

```bash
./bin/webpack-dev-server --host example.com --inline true --hot false
```


## Configuration


### Webpack

Webpacker gives you a default set of configuration files for test, development and
production environments in `config/webpack/*.js`. You can configure each individual
environment in their respective files or configure them all in the base
`config/webpack/environment.js` file.

By default, you shouldn't have to make any changes to `config/webpack/*.js`
files since it's all standard production-ready configuration. However,
if you do need to customize or add a new loader, this is where you would go.


### Loaders

You can add additional loaders beyond the base set that webpacker provides by
adding it to your environment. We'll use `json-loader` as an example:

```
yarn add json-loader
```

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

environment.loaders.add('json', {
  test: /\.json$/,
  use: 'json-loader'
})

module.exports = environment
```

Finally add `.json` to the list of extensions in `config/webpacker.yml`. Now if you `import()` any `.json` files inside your javascript
they will be processed using `json-loader`. Voila!

You can also modify the loaders that webpacker pre-configures for you. We'll update
the `babel` loader as an example:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

// Update an option directly
const babelLoader = environment.loaders.get('babel')
babelLoader.options.cacheDirectory = false

module.exports = environment
```

### Plugins

The process for adding or modifying webpack plugins is the same as the process
for loaders above:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

// Get a pre-configured plugin
environment.plugins.get('ExtractText') // Is an ExtractTextPlugin instance

// Add an additional plugin of your choosing
environment.plugins.add('Fancy', new MyFancyWebpackPlugin)

module.exports = environment
```

### Paths

By default, webpacker ships with simple conventions for where the javascript
app files and compiled webpack bundles will go in your rails app,
but all these options are configurable from `config/webpacker.yml` file.

The configuration for what Webpack is supposed to compile by default rests
on the convention that every file in `app/javascript/packs/*`**(default)**
or whatever path you set for `source_entry_path` in the `webpacker.yml` configuration
is turned into their own output files (or entry points, as Webpack calls it).

Suppose you want to change the source directory from `app/javascript`
to `frontend` and output to `assets/packs`. This is how you would do it:

```yml
# config/webpacker.yml
source_path: frontend
source_entry_path: packs
public_output_path: assets/packs # outputs to => public/assets/packs
```

Similarly you can also control and configure `webpack-dev-server` settings from `config/webpacker.yml` file:

```yml
# config/webpacker.yml
development:
  dev_server:
    host: localhost
    port: 8080
```

If you have `hmr` turned to true, then the `stylesheet_pack_tag` generates no output, as you will want to configure your styles to be inlined in your JavaScript for hot reloading. During production and testing, the `stylesheet_pack_tag` will create the appropriate HTML tags.

#### Resolved Paths

If you are adding webpacker to an existing app that has most of the assets inside
`app/assets` or inside an engine and you want to share that
with webpack modules then you can use `resolved_paths`
option available in `config/webpacker.yml`, which lets you
add additional paths webpack should lookup when resolving modules:

```yml
resolved_paths: ['app/assets']
```

You can then import them inside your modules like so:

```js
// Note it's relative to parent directory i.e. app/assets
import 'stylesheets/main'
import 'images/rails.png'
```

**Note:** Please be careful when adding paths here otherwise it
will make the compilation slow, consider adding specific paths instead of
whole parent directory if you just need to reference one or two modules

## How-tos


### App structure

Let's say you're building a calendar app. Your JS app structure could look like this:

```js
// app/javascript/packs/calendar.js

import 'calendar'
```

```
app/javascript/calendar/index.js // gets loaded by import 'calendar'
app/javascript/calendar/components/grid.jsx
app/javascript/calendar/styles/grid.sass
app/javascript/calendar/models/month.js
```

```erb
<%# app/views/layouts/application.html.erb %>

<%= javascript_pack_tag 'calendar' %>
<%= stylesheet_pack_tag 'calendar' %>
```

But it could also look a million other ways.


#### Namespacing

You can also namespace your packs using directories similar to a Rails app.

```
app/javascript/packs/admin/orders.js
app/javascript/packs/shop/orders.js
```

and reference them in your views like this:

```erb
<%# app/views/admin/orders/index.html.erb %>

<%= javascript_pack_tag 'admin/orders' %>
```

and

```erb
<%# app/views/shop/orders/index.html.erb %>

<%= javascript_pack_tag 'shop/orders' %>
```


### Pass data from view


#### React

If you need more advanced React-integration, like server rendering, redux, or react-router, see [shakacode/react_on_rails](https://github.com/shakacode/react_on_rails), [react-rails](https://github.com/reactjs/react-rails), and [webpacker-react](https://github.com/renchap/webpacker-react).

If you're not concerned with view helpers to pass props or server rendering, can do it yourself:

```erb
<%# views/layouts/application.html.erb %>

<%= content_tag :div,
  id: "hello-react",
  data: {
    message: 'Hello!',
    name: 'David'
}.to_json do %>
<% end %>
```

```js
// app/javascript/packs/hello_react.js

const Hello = props => (
  <div className='react-app-wrapper'>
    <img src={clockIcon} alt="clock" />
    <h5 className='hello-react'>
      {props.message} {props.name}!
    </h5>
  </div>
)

// Render component with data
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))

  ReactDOM.render(<Hello {...data} />, node)
})
```


#### Vue

Add the data as attributes in the element you are going to use (or any other element for that matter).

```erb
<%= content_tag :div,
  id: "hello-vue",
  data: {
    message: "Hello!",
    name: "David"
  }.to_json do %>
<% end %>
```

This should produce the following HTML:

```html
<div id="hello-vue" data="{&quot;message&quot;:&quot;Hello!&quot;,&quot;name&quot;:&quot;David&quot;}"></div>
```

Now, modify your Vue app to expect the properties.

```html
<template>
  <div id="app">
    <p>{{test}}{{message}}{{name}}</p>
  </div>
</template>

<script>
  export default {
    // A child component needs to explicitly declare
    // the props it expects to receive using the props option
    // See https://vuejs.org/v2/guide/components.html#Props
    props: ["message","name"],
    data: function () {
      return {
          test: 'This will display: ',
      }
    }
  }
</script>

<style>
</style>

```


```js
document.addEventListener('DOMContentLoaded', () => {
  // Get the properties BEFORE the app is instantiated
  const node = document.getElementById('hello-vue')
  const props = JSON.parse(node.getAttribute('data'))

  // Render component with props
  new Vue({
    render: h => h(App, { props })
  }).$mount('#hello-vue');
})
```

You can follow same steps for Angular too.


### Add common chunks

The CommonsChunkPlugin is an opt-in feature that creates a separate file (known as a chunk), consisting of common modules shared between multiple entry points. By separating common modules from bundles, the resulting chunked file can be loaded once initially, and stored in the cache for later use. This results in page speed optimizations as the browser can quickly serve the shared code from the cache, rather than being forced to load a larger bundle whenever a new page is visited.

Add the plugins in `config/webpack/environment.js`:

```js
environment.plugins.add('CommonsChunkVendor', new webpack.optimize.CommonsChunkPlugin({
  name: 'vendor',
  minChunks: (module) => {
    // this assumes your vendor imports exist in the node_modules directory
    return module.context && module.context.indexOf('node_modules') !== -1;
  }
}))

environment.plugins.add('CommonsChunkManifest', new webpack.optimize.CommonsChunkPlugin({
  name: 'manifest',
  minChunks: Infinity
}))
```

Now, add these files to your `layouts/application.html.erb`:

```erb
<%# Head %>

<%= javascript_pack_tag 'manifest' %>
<%= javascript_pack_tag 'vendor' %>

<%# If importing any styles from node_modules in your JS app %>

<%= stylesheet_pack_tag 'vendor' %>
```


### Module import() vs require()

While you are free to use `require()` and `module.exports`, we encourage you
to use `import` and `export` instead since it reads and looks much better.

```js
import Button from 'react-bootstrap/lib/Button'

// or
import { Button } from 'react-bootstrap'

class Foo {
  // code...
}

export default Foo
import Foo from './foo'
```

You can also use named export and import

```js
export const foo = () => console.log('hello world')
import { foo } from './foo'
```


### Add a new npm module

To add any new JS module you can use `yarn`:

```bash
yarn add bootstrap material-ui
```


### Add bootstrap

You can use yarn to add bootstrap or any other modules available on npm:

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


### Use Typescript with React

1. Setup react using webpacker [react installer](#react). Then add required depedencies
for using typescript with React:

```bash
yarn add ts-loader typescript @types/react @types/react-dom

# You don't need this with typescript
yarn remove prop-types
```

2. Add a `tsconfig.json` to project root:

``` json
{
  "compilerOptions": {
    "declaration": false,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "lib": ["es6", "dom"],
    "module": "es6",
    "moduleResolution": "node",
    "sourceMap": true,
    "jsx": "react",
    "target": "es5"
  },
  "exclude": [
    "**/*.spec.ts",
    "node_modules",
    "public"
  ],
  "compileOnSave": false
}
```

3. Finally add `.tsx` to the list of extensions in `config/webpacker.yml`
and rename your generated `hello_react.js` using react installer
to `hello_react.tsx` and make it valid typescript and now you can use
typescript, JSX with React.


### Use HTML templates with Typescript and Angular

After you have installed angular using [angular installer](#angular-with-typescript)
you would need to follow these steps to add HTML templates support:

1. Use `yarn` to add html-loader

```bash
yarn add html-loader
```

2. Add html-loader to `config/webpack/environment.js`

```js
environment.loaders.add('html', {
  test: /\.html$/,
  use: [{
    loader: 'html-loader',
    options: {
      minimize: true,
      removeAttributeQuotes: false,
      caseSensitive: true,
      customAttrSurround: [ [/#/, /(?:)/], [/\*/, /(?:)/], [/\[?\(?/, /(?:)/] ],
      customAttrAssign: [ /\)?\]?=/ ]
    }
  }]
})
```

3. Add `.html` to `config/webpacker.yml`

```yml
  extensions:
    - .elm
    - .coffee
    - .html
```

4. Setup a custom `d.ts` definition

```ts
// app/javascript/hello_angular/html.d.ts

declare module "*.html" {
  const content: string
  export default content
}
```

5. Add a template.html file relative to `app.component.ts`

```html
<h1>Hello {{name}}</h1>
```

6. Import template into `app.component.ts`

```ts
import { Component } from '@angular/core'
import templateString from './template.html'

@Component({
  selector: 'hello-angular',
  template: templateString
})

export class AppComponent {
  name = 'Angular!'
}
```

That's all. Voila!

### Ignoring swap files

If you are using vim or emacs and want to ignore certain files you can add `ignore-loader`:

```
yarn add ignore-loader
```

and add `ignore-loader` to `config/webpack/environment.js`

```js
// ignores vue~ swap files
const { environment } = require('@rails/webpacker')
environment.loaders.add('ignore', {
  test:  /.vue~$/,
  loader: 'ignore-loader'
})
```

And now all files with `.vue~` will be ignored by the webpack compiler.


#### Caching

By default, the lazy compilation is cached until a file is changed under
tracked paths. You can configure the paths tracked
by adding new paths to `watched_paths` array, much like rails `autoload_paths`:

```rb
# config/initializers/webpacker.rb
# or config/application.rb
Webpacker::Compiler.watched_paths << 'bower_components'
```

## License
Webpacker is released under the [MIT License](https://opensource.org/licenses/MIT).
