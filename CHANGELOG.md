## [1.2] - 2017-04-27
Some of the changes made requires you to run below commands to install new changes.

```bash
bundle update webpacker
bundle exec rails webpacker:install
```

### Fixed
- Support Spring - [#205](https://github.com/rails/webpacker/issues/205)

  ```ruby
    Spring.after_fork {  Webpacker.bootstrap } if defined?(Spring)
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

```bash
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
