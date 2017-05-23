# Webpacker

![travis-ci status](https://api.travis-ci.org/rails/webpacker.svg?branch=master)
[![node.js](https://img.shields.io/badge/node-%3E%3D%206.4.0-brightgreen.svg)](https://nodejs.org/en/)
[![Gem](https://img.shields.io/gem/v/webpacker.svg)](https://github.com/rails/webpacker)

Webpacker makes it easy to use the JavaScript preprocessor and bundler
[Webpack 2.x.x+](https://webpack.js.org/)
to manage application-like JavaScript in Rails. It coexists with the asset pipeline,
as the primary purpose for Webpack is app-like JavaScript, not images, css, or
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
  - [Elm](#elm)
- [Binstubs](#binstubs)
  - [Webpack dev server](#webpack-dev-server)
  - [Webpack watcher](#webpack-watcher)
- [Configuration](#configuration)
  - [Webpack](#webpack)
  - [Loaders](#loaders)
  - [Paths](#paths)
  - [Babel](#babel)
  - [Post-Processing CSS](#post-processing-css)
  - [CDN](#cdn)
  - [HTTPS in Development](#https-in-development)
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
  - [Add a new npm module](#add-a-new-npm-module)
  - [Module import() vs require()](#module-import-vs-require)
  - [Add bootstrap](#add-bootstrap)
  - [Add Typescript with React](#add-typescript-with-react)
  - [Ignoring swap files](#ignoring-swap-files)
  - [Link sprocket assets](#link-sprocket-assets)
    - [Using helpers](#using-helpers)
    - [Using babel module resolver](#using-babel-module-resolver)
- [Deployment](#deployment)
  - [Heroku](#heroku)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Wishlist](#wishlist)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Prerequisites

* Ruby 2.2+
* Rails 4.2+
* Node.js 6.4.0+
* Yarn 0.20.1+


## Features

* [Webpack 2](https://webpack.js.org/) ready
* ES6 ready with [babel](https://babeljs.io/)
* Automatic code splitting using multiple entry points
* Stylesheet ready - sass and css
* Images and fonts ready
* PostCSS ready
* Asset compression, source-maps and minification
* CDN ready
* React, Angular, Elm and Vue support out-of-the-box
* Rails view helpers
* Extensible and configurable
* Test suite ready


## Installation

You can either add Webpacker during setup of a new Rails 5.1+ application
using new `--webpack` option:

```bash
# Available Rails 5.1+
./bin/rails new myapp --webpack
```

Or add it to your existing `Gemfile`, run bundle and `./bin/rails webpacker:install` or `bundle exec rake webpacker:install` (with rails version < 5.0):

```ruby
# Gemfile
gem 'webpacker', '~> 2.0'

# OR if you prefer to use master
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'
```

**Note:** Use `rake` instead of `rails` if you are using webpacker
with rails version < 5.0


## Integrations

Webpacker by default ships with basic out-of-the-box integration
for React, Angular, Vue and Elm. You can see a list of available
commands/tasks by running `./bin/rails webpacker` or `./bin/rake webpacker`
in rails version < 5.0


### React

To use Webpacker with [React](https://facebook.github.io/react/), create a
new Rails app using new `--webpack=react` option:

```bash
# Rails 5.1+
./bin/rails new myapp --webpack=react
```

(or run `./bin/rails webpacker:install:react` in a existing Rails app already
setup with webpacker).

The installer will add all relevant dependencies using yarn, any changes
to the configuration files and an example React component to your
project in `app/javascript/packs` so that you can experiment with React right away.


### Angular with TypeScript

To use Webpacker with [Angular](https://angularjs.org/), create a
new Rails app using new `--webpack=angular` option:

```bash
# Rails 5.1+
./bin/rails new myapp --webpack=angular
```

(or run `./bin/rails webpacker:install:angular` on a Rails app already
setup with webpacker).

The installer will add TypeScript and Angular core libraries using yarn plus
any changes to the configuration files. An example component written in
TypeScript will also be added to your project in `app/javascript` so that
you can experiment with Angular right away.


### Vue

To use Webpacker with [Vue](https://vuejs.org/), create a
new Rails app using new `--webpack=vue` option:

```bash
# Rails 5.1+
./bin/rails new myapp --webpack=vue
```
(or run `./bin/rails webpacker:install:vue` on a Rails app already setup with webpacker).

The installer will add Vue and required libraries using yarn plus
any changes to the configuration files. An example component will
also be added to your project in `app/javascript` so that you can
experiment Vue right away.


### Elm

To use Webpacker with [Elm](http://elm-lang.org), create a
new app using new `--webpack=elm` option:

```
./bin/rails new myapp --webpack=elm
```

(or run `./bin/rails webpacker:install:elm` on a Rails app already setup with webpacker).

The Elm library and core packages will be added via Yarn and Elm itself.
An example `Main.elm` app will also be added to your project in `app/javascript`
so that you can experiment with Elm right away.


## Binstubs

Webpacker ships with two binstubs: `./bin/webpack` and `./bin/webpack-dev-server`.
They're thin wrappers around the standard `webpack.js` and `webpack-dev-server.js`
executable to ensure that the right configuration file is loaded
depending on your environment.


### Webpack dev server

In development, you'll need to run `./bin/webpack-dev-server` in a separate terminal
from `./bin/rails server` to have your `app/javascript/packs/*.js` files compiled
as you make changes.

`./bin/webpack-dev-server` launches the [Webpack Dev Server](https://webpack.js.org/configuration/dev-server/), which serves your pack files
on `http://localhost:8080/` by default and supports live code reloading in development environment. You will need to install additional plugins for Webpack if you want features like [Hot Module Replacement](https://webpack.js.org/guides/hmr-react/)

If you'd rather not have to run the two processes separately by hand, you can use [Foreman](https://ddollar.github.io/foreman):

```bash
gem install foreman
```

```yml
# Procfile
web: bundle exec rails s
webpacker: ./bin/webpack-dev-server
```

```bash
foreman start
```

You can also pass additional cli options supported by [webpack-dev-server](https://webpack.js.org/configuration/dev-server/). Please note that inline
options will always take precedence over the ones
already set in the configuration file.

```bash
./bin/webpack-dev-server --host 0.0.0.0 --inline true --hot false
```


### Webpack watcher

We recommend using `webpack-dev-server` during development for better experience,
however if you don't want that for some reason you can always use `webpack` binstub in
watch mode. This will use `public_output_path` from `config/webpacker.yml`
directory to serve your packs using configured rails server.

You can provide additional cli options to `watcher` available
in [Webpack](https://webpack.js.org/api/cli/).

```bash
./bin/webpack --watch --progress --colours
```


## Configuration


### Webpack

Webpacker gives you a default set of configuration files for test, development and
production environments. They all live together with the shared
points in `config/webpack/*.js`.

![screen shot 2017-05-23 at 19 56 18](https://cloud.githubusercontent.com/assets/771039/26371229/0983add2-3ff2-11e7-9dc3-d9c2c1094032.png)

By default, you shouldn't have to make any changes to `config/webpack/*.js`
files since it's all standard production ready configuration however
if you do need to customise this is where you would go.


### Loaders

Webpack enables use of loaders to preprocess files. This allows you to
bundle any static resource way beyond JavaScript. All base loaders
that ships with webpacker are located inside `config/webpack/loaders`.

If you want to add a new loader, for example to process `json` files via webpack:

```
yarn add json-loader
```

and create a `json.js` file inside `loaders` directory:

```js
module.exports = {
  test: /\.json$/,
  use: 'json-loader'
}
```

Now if you import('data.json') any `.json` files inside your javascript
they will be processed using `json-loader`. Voila!


### Paths

By default, webpacker ships with simple conventions for where the javascript
app files and compiled webpack bundles will go in your rails app,
but all these options are configurable from `config/webpacker.yml` file.

The configuration for what Webpack is supposed to compile by default rests
on the convention that every file in `app/javascript/packs/*`**(default)**
or whatever path you set for `source_entry_path` in the `webpacker.yml` configuration
is turned into their own output files (or entry points, as Webpack calls it).

Suppose you want to change the source directory from `app/javascript`
to `frontend` and entry directory from `packs` to `modules`
this is how you would do it:

```yml
# config/webpacker.yml
source_path: frontend
source_entry_path: modules
public_output_path: modules
```

Similary you can also control and configure `webpack-dev-server` settings from
`config/webpacker.yml` file:

```yml
# config/webpacker.yml
development:
  dev_server:
    host: 0.0.0.0
    port: 8080
    https: false
```


### Babel

Webpacker ships with [babel](https://babeljs.io/) - a JavaScript compiler so,
you can use next generation JavaScript, today. The Webpacker installer sets up a default standard `.babelrc` file in your app root, which will work great in most cases
because of [babel-env-preset](https://github.com/babel/babel-preset-env).

Following ES6/7 features are supported out of the box:

* Async/await.
* Object Rest/Spread Properties.
* Exponentiation Operator.
* Dynamic import() - useful for route level code-splitting
* Class Fields and Static Properties.

We have also included [babel polyfill](https://babeljs.io/docs/usage/polyfill/)
that includes a custom regenerator runtime and core-js.


### Post-Processing CSS

Webpacker out-of-the-box provides CSS post-processing using
[postcss-loader](https://github.com/postcss/postcss-loader)
and the installer sets up a standard `.postcssrc.yml` file in your app root
with standard plugins.

```yml
plugins:
  postcss-smart-import: {}
  precss: {}
  autoprefixer: {}
```


### CDN

Webpacker out-of-the-box provides CDN support using `ASSET_HOST` environment variable
set within your Rails app. You don't need to do anything extra, it just works. Voila!


### HTTPS in Development

You may require the `webpack-dev-server` to serve views over HTTPS.
To do this, set the `https` option for `webpack-dev-server`
to true in `development.server.js`, then start the dev server as usual
with `./bin/webpack-dev-server`:

Please note that the `webpack-dev-server` will use a self-signed certificate,
so your web browser will display a warning upon accessing the page.


### Hot module replacement

Webpacker out-of-the-box doesn't ships with HMR just yet. You will need to install additional plugins for Webpack if you want to add HMR support.

You can checkout these links on this subject,
https://webpack.js.org/configuration/dev-server/#devserver-hot
https://webpack.js.org/guides/hmr-react/


## Linking Styles, Images and Fonts

Static assets like images, fonts and stylesheets support is enabled out-of-box and you can link them into your javascript app code and have them compiled automatically.


### Within your JS app

```sass
// app/javascript/hello_react/styles/hello-react.sass

.hello-react
  padding: 20px
  font-size: 12px
```

```js
// React component example
// app/javascripts/packs/hello_react.jsx

import React from 'react'
import ReactDOM from 'react-dom'
import helloIcon from '../hello_react/images/icon.png'
import '../hello_react/styles/hello-react.sass'

const Hello = props => (
  <div className="hello-react">
    <img src={helloIcon} alt="hello-icon" />
    <p>Hello {props.name}!</p>
  </div>
)
```


### Inside views

Under the hood webpack uses
[extract-text-webpack-plugin](https://github.com/webpack-contrib/extract-text-webpack-plugin) plugin to extract all the referenced styles and compile it into
a separate `[pack_name].css` bundle so that within your view you can use the
`stylesheet_pack_tag` helper,

```erb
<%= stylesheet_pack_tag 'hello_react' %>
```

You can also link js/images/styles used within your js app in views using `asset_pack_path` helper. This helper is useful in cases where you want to
create a `<link rel="prefetch">` or `<img />` for an asset used in your pack code,

```erb
<%= asset_pack_path 'hello_react.css' %>
<% # => "/packs/hello_react.css" %>

<img src="<%= asset_pack_path 'calendar.png' %>" />
<% # => <img src="/packs/calendar.png" /> %>
```


### From node modules folder

You can also import styles from `node_modules` using following syntax.
Please note that your styles will always be extracted into `[pack_name].css`:

```sass
// app/javascript/app-styles.sass
//  ~ to tell webpack that this is not a relative import:

@import '~@material/animation/mdc-animation.scss'
@import '~boostrap/dist/bootstrap.css'
```

```js
// app/javascript/packs/app.js
import '../app-styles'
```

```erb
<%= stylesheet_pack_tag 'app' %>
```


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

You may consider using [react-rails](https://github.com/reactjs/react-rails) or
[webpacker-react](https://github.com/renchap/webpacker-react) for more advanced react integration. However here is how you can do it yourself:

```erb
# views/layouts/application.html.erb

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

```erb
<%= content_tag :div,
  id: "hello-vue",
  data: {
    message: "Hello!",
    name: "David"
} do %>
<% end %>
```

```html
<div id="hello-vue" data-name="David" data-message="Hello!"></div>
```

```js
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-vue')
  const data = JSON.parse(node.getAttribute('data'))

  const app = new Vue({
    data: data,
    el: '#vue-app',
    template: '<App/>',
    components: { App }
  })

  console.log(app)
})
```

You can follow same steps for Angular too.


### Add a new npm module

To add any new JS module you can use `yarn`:

```bash
yarn add bootstrap material-ui
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


### Add bootstrap

You can use yarn to add bootstrap or any other modules available on npm:

```bash
yarn add bootstrap
```

Import Bootstrap and theme(optional) CSS in your app/javascript/packs/app.js file:

```js
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap/dist/css/bootstrap-theme.css';
```

Or in your app/javascript/app.sass file:

```sass
@import '~bootstrap/dist/css/bootstrap.css';
@import '~bootstrap/dist/css/bootstrap-theme.css';
```


### Add Typescript with React

1. Setup react using webpacker [react installer]((#react)):

```bash
yarn add ts-loader typescript @types/react @types/react-dom

# Don't need this with typescript
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

3. Add a new loader `config/webpack/loaders/typescript.js`:

``` js
module.exports = {
  test: /.(ts|tsx)$/,
  loader: 'ts-loader'
}
```

4. And finally, add `.tsx` to the list of extensions in `config/webpacker.yml`
and rename your generated `hello_react.js` using react installer
to `hello_react.tsx` and make it valid typescript and now you can use
typescript with React.


### Ignoring swap files

If you are using vim or emacs and want to ignore certain
files you can add `ignore-loader`:

```
yard add ignore-loader
```

and create a new loader:

```js
// config/webpack/loaders/ignores.js
// ignores vue~ swap files
module.exports = {
  test: /.vue~$/,
  loader: 'ignore-loader'
}
```

### Link sprocket assets


#### Using helpers

It's possible to link to assets that have been precompiled by sprockets.
Add the `.erb` extension to your javascript file, then you can
use Sprockets' asset helpers:

```erb
// app/javascript/my_pack/example.js.erb

<% helpers = ActionController::Base.helpers %>
var railsImagePath = "<%= helpers.image_path('rails.png') %>";
```

This is enabled by the `rails-erb-loader` loader rule in `config/webpack/shared.js`.


#### Using babel module resolver

You can use [babel-plugin-module-resolver](https://github.com/tleunen/babel-plugin-module-resolver) to reference assets directly from `app/assets/**`

```bash
yarn add babel-plugin-module-resolver
```

Specify the plugin in your .babelrc with the custom root or alias. Here's an example:

```json
{
  "plugins": [
    ["module-resolver", {
      "root": ["./app"],
      "alias": {
        "assets": "./assets"
      }
    }]
  ]
}
```

And then within your javascript app code:

```js
import FooImage from 'assets/images/foo-image.png'
import 'assets/stylesheets/bar.sass'
```


## Deployment

Webpacker hooks up a new `webpacker:compile` task to `assets:precompile`, which gets run whenever you run `assets:precompile`. If you are not using sprockets you
can manually trigger `bundle exec rails webpacker:compile` during your app deploy.

The `javascript_pack_tag` and `stylesheet_pack_tag` helper method will automatically insert the correct HTML tag for compiled pack. Just like the asset pipeline does it. By default the output will look like this in different environments,

```html
  <!-- In development mode with webpack-dev-server -->
  <script src="http://localhost:8080/calendar.js"></script>
  <link rel="stylesheet" media="screen" href="http://localhost:8080/calendar.css">
  <!-- In development mode -->
  <script src="/packs/calendar.js"></script>
  <link rel="stylesheet" media="screen" href="/packs/calendar.css">
  <!-- In production mode -->
  <script src="/packs/calendar-0bd141f6d9360cf4a7f5.js"></script>
  <link rel="stylesheet" media="screen" href="/packs/calendar-dc02976b5f94b507e3b6.css">
```


### Heroku

Heroku installs yarn and node by default if you deploy a rails app with
Webpacker so all you would need to do:

```bash
heroku create shiny-webpacker-app
heroku addons:create heroku-postgresql:hobby-dev
git push heroku master
```


## Testing

Webpacker lazily compiles assets in test env so you can write your tests without any extra
setup and everything will work out of the box.

```js
import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const Hello = props => (
  <div>Hello {props.name}!</div>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Hello name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
})
```

```erb
<%= javascript_pack_tag "hello_react" %>
```

```rb
# Tests example react component
require "application_system_test_case"
class HomesTest < ApplicationSystemTestCase
  test "can see the hello message" do
    visit root_url
    assert_selector "h5", text: "Hello! David"
  end
end
```


## Troubleshooting

*  If you get this error `ENOENT: no such file or directory - node-sass` on Heroku
or elsewhere during `assets:precompile` or `bundle exec rails webpacker:compile`
then you would need to rebuild node-sass. It's a bit weird error,
basically, it can't find the `node-sass` binary.
An easy solution is to create a postinstall hook - `npm rebuild node-sass` in
`package.json` and that will ensure `node-sass` is rebuild whenever
you install any new modules.

* If you get this error `Can't find hello_react.js in manifest.json`
when loading a view in browser it's because Webpack is still compiling packs.
Webpacker uses a `manifest.json` file to keep track of packs in all environments,
however since this file is generated after packs are compiled by webpack. So,
if you load a view in browser whilst webpack is compiling you will get this error.
Therefore, make sure webpack
(i.e `./bin/webpack-dev-server`) is running and has
completed the compilation successfully before loading a view.


## Wishlist

- HMR - [#188](https://github.com/rails/webpacker/issues/188)
- Support rails engines - [#348](https://github.com/rails/webpacker/issues/348)


## License
Webpacker is released under the [MIT License](https://opensource.org/licenses/MIT).
