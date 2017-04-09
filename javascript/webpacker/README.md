<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

`webpacker-scripts` allows you to use webpack 2 with zero build configuration.

- [Webpacker Scripts](#webpacker-scripts)
  - [Prerequisites](#prerequisites)
  - [Features](#features)
  - [Usage with Webpacker and Rails](#usage-with-webpacker-and-rails)
  - [Standalone usage](#standalone-usage)
  - [Scripts](#scripts)
  - [Configuration](#configuration)
  - [Advanced Configuration](#advanced-configuration)
  - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Webpacker Scripts
![travis-ci status](https://api.travis-ci.org/rails/webpacker.svg?branch=master)
[![node.js](https://img.shields.io/badge/node-%3E%3D%206.4.0-brightgreen.svg)](https://nodejs.org/en/)
[![Gem](https://img.shields.io/gem/v/webpacker.svg)](https://github.com/rails/webpacker)

Webpacker Scripts is a collection of opinionated node scripts and webpack config files built
exclusively for new [Webpacker](https://github.com/rails/webpacker) gem, however, it is possible to use
it as a standalone package with some extra setup.

## Prerequisites

* Node.js 6.4.0+
* Yarn
* Webpacker gem

## Features

* [Webpack 2](https://webpack.js.org/) Ready
* [HMR](https://webpack.js.org/concepts/hot-module-replacement/) Ready
* [Webpack Dev Server](https://webpack.js.org/configuration/dev-server/)
* Code splitting using multiple entry points
* Stylesheet Ready with support for HMR and CSS modules
* PostCSS Ready
* Asset compression and minification
* React, Angular and Vue support out-of-the-box
* Extensible

## Usage with Webpacker and Rails

Webpacker Scripts comes bundled by default with the new webpacker gem, which means that
whenever you run `bundle exec rails webpacker:install` it will install `webpacker-scripts` package for you, however, you can also manually add it by running `yarn add webpacker-scripts`
in an existing Rails project.

## Standalone usage

Webpacker Scripts is built exclusively for new Webpacker gem, but since this is just
standard node package you can use it in any other project with some extra setup.

The extra step required
for you to copy the webpacker config files from the gem repo to your project in same
structure i.e. `config/webpack/[*.yml]`. You might also wanna copy the `.postcssrc.yml` and
`.babelrc` to your project root for postcss and babel to compile files properly.

## Scripts

Webpacker Scripts comes with two tasks -`build` and `start`, which can be run
using `webpacker` binary once installed.

```bash
./node_modules/.bin/webpacker start
./node_modules/.bin/webpacker build
```

Start tasks starts the `webpack-dev-server` in development environment, where as the build
the task is designed to produce optimized production app bundle.

## Configuration

Webpacker Scripts references all configuration settings from `config/webpack/*.yml` files, which are pretty well documented. When you create new rails 5.1 apps with `--webpack` option or run the webpacker installer manually these files will be copied automatically for you by the installer to `config/webpack` directory.

```yml
# config/webpack/paths.yml
source: app/javascript
entry: packs
output: public
```

*Note:* Behind the scenes, webpacker will use same `entry` directory name inside `output`
directory to emit bundles. For ex, `public/packs`

Similary, you can also control and configure `webpack-dev-server` settings from
`config/webpack/development.server.yml` file

```yml
# config/webpack/development.server.yml
enabled: true
host: localhost
port: 8080
```

By default, `webpack-dev-server` uses `output` option specified in
`paths.yml` as `contentBase`.

## Advanced Configuration

Webpacker Scripts allows overriding built-in webpack config files with your own configuration. All you have to do is create a `config/webpack/webpack.config.js` and export
a `webpack` function that extends base webpack config.

For example, lets say you want to add `react-hot-loader` entry point, you can  do
it like so,

```js
// config/webpack/webpack.config.js
const merge = require('webpack-merge')
module.exports = {
  webpack: (webpackConfig,  { ifDevelopment, ifProduction, ifTest, env }) => {
    if (ifDevelopment()) {
      const reactHotClient = ['react-hot-loader/patch']
      Object.keys(webpackConfig.entry).forEach((key) => {
        webpackConfig.entry[key] = reactHotClient.concat(webpackConfig.entry[key]);
      })
    }
    // Important: return the webpackConfig
    return webpackConfig
  }
}
```

Similarly, you can also add your own loaders that don't come out of the box with `webpacker-scripts`, just create a `loaders` directory under `config/webpack` and export
your loader module and that's it.

For example, lets say you want to add the `html-loader`, you can do it like so:

```js
// config/webpack/loaders/html.js
module.exports = {
  test: /\.html$/,
  use: [{
    loader: 'html-loader',
    options: {
      minimize: true
    }
  }]
}
```

## License
Webpacker is released under the [MIT License](https://opensource.org/licenses/MIT).
