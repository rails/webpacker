### Fixed
- Update `.babelrc` to fix compilation issues - [#306](https://github.com/rails/webpacker/issues/306)

- Duplicated asset hosts - [#320](https://github.com/rails/webpacker/issues/320), [#397](https://github.com/rails/webpacker/pull/397)

- Missing asset host when defined as a `Proc` or on `ActionController::Base.asset_host` directly - [#397](https://github.com/rails/webpacker/pull/397)

- Incorrect asset host when running `webpacker:compile` or `bin/webpack` in development mode - [#397](https://github.com/rails/webpacker/pull/397)

### Added
- [Elm](http://elm-lang.org) support. You can now add Elm support via the following methods:
  - New app: `rails new <app> --webpack=elm`
  - Within an existing app: `rails webpacker:install:elm`

- Support for custom `output` paths independent of `entry` in `paths.yml`. `output` is also now relative to `public/`. - [#397](https://github.com/rails/webpacker/pull/397)

    Before (compile to `public/packs`):
    ```yaml
    entry: packs              
    output: public
    ```
    After (compile to `public/sweet/js`):
    ```yaml
    entry: packs
    output: sweet/js
    ```

## [1.2] - 2017-04-27
Some of the changes made requires you to run below commands to install new changes.

```
bundle update webpacker
bundle exec rails webpacker:install
```

### Fixed
- Support Spring - [#205](https://github.com/rails/webpacker/issues/205)

  ```ruby
  Spring.after_fork { Webpacker.bootstrap } if defined?(Spring)
  ```
- Check node version and yarn before installing webpacker - [#217](https://github.com/rails/webpacker/issues/217)

- Include webpacker helper to views - [#172](https://github.com/rails/webpacker/issues/172)

- Webpacker installer on windows - [#245](https://github.com/rails/webpacker/issues/245)

- Yarn duplication - [#278](https://github.com/rails/webpacker/issues/278)

- Add back Spring for `rails-erb-loader` - [#216](https://github.com/rails/webpacker/issues/216)

- Move babel presets and plugins to .babelrc - [#202](https://github.com/rails/webpacker/issues/202)

### Added
- A changelog - [#211](https://github.com/rails/webpacker/issues/211)
- Minimize CSS assets - [#218](https://github.com/rails/webpacker/issues/218)
- Pack namespacing support - [#201](https://github.com/rails/webpacker/pull/201)

  For example:
  ```
  app/javascript/packs/admin/hello_vue.js
  app/javascript/packs/admin/hello.vue
  app/javascript/packs/hello_vue.js
  app/javascript/packs/hello.vue
  ```
- Add tree-shaking support - [#250](https://github.com/rails/webpacker/pull/250)
- Add initial test case by @kimquy [#259](https://github.com/rails/webpacker/pull/259)
- Compile assets before test:controllers and test:system

### Removed
- Webpack watcher - [#295](https://github.com/rails/webpacker/pull/295)

## [1.1] - 2017-03-24

This release requires you to run below commands to install new features.

```
bundle update webpacker
bundle exec rails webpacker:install
# if installed react, vue or angular
bundle exec rails webpacker:install:[react, angular, vue]
```

### Added (breaking changes)
- Static assets support - [#153](https://github.com/rails/webpacker/pull/153)
- Advanced webpack configuration - [#153](https://github.com/rails/webpacker/pull/153)

### Removed

```rb
config.x.webpacker[:digesting] = true
```
