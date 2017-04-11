## [Unreleased]
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
