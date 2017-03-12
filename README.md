# Webpacker
![travis-ci status](https://api.travis-ci.org/rails/webpacker.svg?branch=master)

Webpacker makes it easy to use the JavaScript preprocessor and bundler [Webpack](https://webpack.github.io)
to manage application-like JavaScript in Rails. It coexists with the asset pipeline,
as the purpose is only to use Webpack for app-like JavaScript, not images, css, or
even JavaScript Sprinkles (that all continues to live in app/assets).

It's designed to work with Rails 5.1+ and makes use of the [Yarn](https://yarnpkg.com) dependency management
that's been made default from that version forward.

## Installation

Webpacker is currently compatible with Rails 4.2+, but there's no guarantee it will still be
in the future.

You can either make use of Webpacker during setup of a new application with `--webpack`
or you can add the gem and run `./bin/rails webpacker:install` in an existing application.

As the rubygems version isn't promised to be kept up to date until the release of Rails 5.1, you may want to include the gem directly from GitHub:

```ruby
gem 'webpacker', github: 'rails/webpacker'
```

You can also see a list of available commands by running `./bin/rails webpacker`

## Binstubs

Webpacker ships with three binstubs: `./bin/webpack`, `./bin/webpack-watcher` and `./bin/webpack-dev-server`.
They're thin wrappers around the standard webpack.js executable, just to ensure that the right configuration
file is loaded.


A binstub is also created to install your npm dependencies,
and can be called via `./bin/yarn`.

In development, you'll need to run `./bin/webpack-watcher` in a separate terminal from
`./bin/rails server` to have your `app/javascript/packs/*.js` files compiled as you make changes.
If you'd rather not have to run the two processes separately by hand, you can use
[Foreman](https://ddollar.github.io/foreman).

Alternatively, you can run `./bin/webpack-dev-server`. This will launch a
[Webpack Dev Server](https://webpack.github.io/docs/webpack-dev-server.html) listening on http://localhost:8080/
serving your pack files. It will recompile your files as you make changes. You also need to set
`config.x.webpacker[:dev_server_host]` in your `config/environments/development.rb` to tell Webpacker to load
your packs from the Webpack Dev Server. This setup allows you to leverage advanced Webpack features, such
as [Hot Module Replacement](https://webpack.github.io/docs/hot-module-replacement-with-webpack.html).


## Configuration

Webpacker gives you a default set of configuration files for development and production. They
all live together with the shared points in `config/webpack/*.js`. By default, you shouldn't have to
make any changes for a basic setup out the box. But this is where you do go if you need something
more advanced.

The configuration for what Webpack is supposed to compile by default rests on the convention that
every file in `app/javascript/packs/*` should be turned into their own output files (or entry points,
as Webpack calls it).

Let's say you're building a calendar. Your structure could look like this:

```erb
<%# app/views/layout/application.html.erb %>
<%= javascript_pack_tag 'calendar' %>
```

```js
// app/javascript/packs/calendar.js
require('calendar')
```

```
app/javascript/calendar/index.js // gets loaded by require('calendar')
app/javascript/calendar/components/grid.jsx
app/javascript/calendar/models/month.js
```

But it could also look a million other ways. The only convention that Webpacker enforces is the
one where entry points are automatically configured by the files in `app/javascript/packs`.

## Advanced Configuration

By default, webpacker provides simple conventions for where the webpack configs, javascript app files and compiled webpack bundles will go in your rails app, but all these are configurable from package.json that comes with webpacker. You can also configure webpack-dev-server host and port in your development environment

```json
{
  "config": {
    "_comment": "Configure webpacker internals (do not remove)",
    "webpacker": {
      "srcPath": "app/javascript",
      "configPath": "config/webpack",
      "nodeModulesPath": "node_modules",
      "distDir": "packs",
      "distPath": "public/packs",
      "manifestFileName": "manifest.json"
    },
    "_comment": "Configure webpack-dev-server",
    "devServer": {
      "enabled": true,
      "host": "localhost",
      "port": "8080",
      "compress": true
    }
  }
}
```

**For ex:** if you rename `packs` directory inside `app/javascript` from `packs` to `bundles`, make sure you also update your `distDir` and `distPath`.

```json
"webpacker": {
  "distDir": "bundles",
  "distPath": "public/bundles",
}
```

**Note:** Do not delete this config otherwise your app will break, unless you really know what you're doing.

## Deployment

Webpacker hooks up a new `webpacker:compile` task to `assets:precompile`, which gets run whenever you run `assets:precompile`. The `javascript_pack_tag` and `stylesheet_pack_tag` helper method will automatically insert the correct HTML tag for compiled pack. Just like the asset pipeline does it. By default the output will look like this in different environments,

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

**Note:** *`stylesheet_pack_tag` helper is not available out-of-the-box.
Check [statics assets](#ready-for-static-assets) support section for more details.*

## Linking to sprockets assets

It's possible to link to assets that have been precompiled by sprockets. Add the `.erb` extension
to your javascript file, then you can use Sprockets' asset helpers:

```
// app/javascript/my_pack/example.js.erb

<% helpers = ActionController::Base.helpers %>
var railsImagePath = "<%= helpers.image_path('rails.png') %>";
```

This is enabled by the `rails-erb-loader` loader rule in `config/webpack/shared.js`.

## Ready for Static Assets

Static assets support isn't enabled out-of-the-box. To enable static assets support in your javascript app you will need to run `rails webpacker:install:assets` after you have installed webpacker. Once installed, you can
link static files like images and styles directly into your javascript app code and
have them properly compiled automatically.

```js
// React component example
// app/javascripts/packs/hello_react.jsx
import React from 'react'
import ReactDOM from 'react-dom'
import clockIcon from '../counter/images/clock.png'
import './hello-react.sass'

const Hello = props => (
  <div className="hello-react">
    <img src={clockIcon} alt="clock" />
    <p>Hello {props.name}!</p>
  </div>
)
```

and then within your view, include the `stylesheet_pack_tag` with the name of your pack,

```erb
<%= stylesheet_pack_tag 'hello_react' %>
```

## Ready for React

To use Webpacker with React, just create a new app with `rails new myapp --webpack=react` (or run `rails webpacker:install:react` on a Rails app already setup with webpacker), and all the relevant dependencies
will be added via yarn and changes to the configuration files made. Now you can create JSX files and
have them properly compiled automatically.

## Ready for Angular with TypeScript

To use Webpacker with Angular, just create a new app with `rails new myapp --webpack=angular` (or run `rails webpacker:install:angular` on a Rails app already setup with webpacker). TypeScript support and the Angular core libraries will be added via yarn and changes to the configuration files made. An example component written in TypeScript is also added to your project in `app/javascript` so that you can experiment Angular right away.

## Ready for Vue

To use Webpacker with Vue, just create a new app with `rails new myapp --webpack=vue` (or run `rails webpacker:install:vue` on a Rails app already setup with webpacker). Vue and its supported libraries will be added via yarn and changes to the configuration files made. An example component is also added to your project in `app/javascript` so that you can experiment Vue right away.


## Wishlist

- Improve process for linking to assets compiled by sprockets - shouldn't need to specify
` <% helpers = ActionController::Base.helpers %>` at the beginning of each file
- Consider chunking setup

## License
Webpacker is released under the [MIT License](https://opensource.org/licenses/MIT).
