# Integrations

Webpacker ships with basic out-of-the-box integration for React, Angular, Vue and Elm.
You can see a list of available commands/tasks by running `bundle exec rails webpacker`:

## React

To use Webpacker with [React](https://facebook.github.io/react/), create a
new Rails 5.1+ app using `--webpack=react` option:

```bash
# Rails 5.1+
rails new myapp --webpack=react
```

(or run `bundle exec rails webpacker:install:react` in an existing Rails app already
setup with Webpacker).

The installer will add all relevant dependencies using Yarn, changes
to the configuration files, and an example React component to your
project in `app/javascript/packs` so that you can experiment with React right away.


## Angular with TypeScript

To use Webpacker with [Angular](https://angular.io/), create a
new Rails 5.1+ app using `--webpack=angular` option:

```bash
# Rails 5.1+
rails new myapp --webpack=angular
```

(or run `bundle exec rails webpacker:install:angular` on a Rails app already
setup with Webpacker).

The installer will add the TypeScript and Angular core libraries using Yarn alongside
a few changes to the configuration files. An example component written in
TypeScript will also be added to your project in `app/javascript` so that
you can experiment with Angular right away.

By default, Angular uses a JIT compiler for development environment. This
compiler is not compatible with restrictive CSP (Content Security
Policy) environments like Rails 5.2+. You can use Angular AOT compiler
in development with the [@ngtools/webpack](https://www.npmjs.com/package/@ngtools/webpack#usage) plugin.

Alternatively if you're using Rails 5.2+ you can enable `unsafe-eval` rule for your
development environment. This can be done in the `config/initializers/content_security_policy.rb`
with the following code:

```ruby
Rails.application.config.content_security_policy do |policy|
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval
  else
    policy.script_src :self, :https
  end
end
```


## Vue

To use Webpacker with [Vue](https://vuejs.org/), create a
new Rails 5.1+ app using `--webpack=vue` option:

```bash
# Rails 5.1+
rails new myapp --webpack=vue
```
(or run `bundle exec rails webpacker:install:vue` on a Rails app already setup with Webpacker).

The installer will add Vue and its required libraries using Yarn alongside
automatically applying changes needed to the configuration files. An example component will
be added to your project in `app/javascript` so that you can experiment with Vue right away.

If you're using Rails 5.2+ you'll need to enable `unsafe-eval` rule for your development environment.
This can be done in the `config/initializers/content_security_policy.rb` with the following
configuration:

```ruby
Rails.application.config.content_security_policy do |policy|
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval
  else
    policy.script_src :self, :https
  end
end
```
You can read more about this in the [Vue docs](https://vuejs.org/v2/guide/installation.html#CSP-environments).

### Lazy loading integration

See [docs/es6](es6.md) to know more about Webpack and Webpacker configuration.

For instance, you can lazy load Vue JS components:

Before:
```js
import Vue from 'vue'
import { VCard } from 'vuetify/lib'

Vue.component('VCard', VCard)
```

After:
```js
import Vue from 'vue'

// With destructuring assignment
Vue.component('VCard', import('vuetify/lib').then(({ VCard }) => VCard)

// Or without destructuring assignment
Vue.component('OtherComponent', () => import('./OtherComponent'))
```

You can use it in a Single File Component as well:

```html
<template>
  ...
</template>

<script>
export default {
  components: {
    OtherComponent: () => import('./OtherComponent')
  }
}
</script>
```

By wrapping the import function into an arrow function, Vue will execute it only when it gets requested, loading the module in that moment.

##### Automatic registration

```js
/**
 * The following block of code may be used to automatically register your
 * Vue components. It will recursively scan this directory for the Vue
 * components and automatically register them with their "basename".
 *
 * Eg. ./components/OtherComponent.vue -> <other-component></other-component>
 * Eg. ./UI/ButtonComponent.vue -> <button-component></button-component>
 */

const files = require.context('./', true, /\.vue$/i)
files.keys().map(key => {
  const component = key.split('/').pop().split('.')[0]

  // With Lazy Loading
  Vue.component(component, () => import(`${key}`))

  // Or without Lazy Loading
  Vue.component(component, files(key).default)
})
```

## Elm

To use Webpacker with [Elm](http://elm-lang.org), create a
new Rails 5.1+ app using `--webpack=elm` option:

```
# Rails 5.1+
rails new myapp --webpack=elm
```

(or run `bundle exec rails webpacker:install:elm` on a Rails app already setup with Webpacker).

The Elm library and its core packages will be added via Yarn and Elm.
An example `Main.elm` app will also be added to your project in `app/javascript`
so that you can experiment with Elm right away.

## Svelte

To use Webpacker with [Svelte](https://svelte.dev), create a
new Rails 5.1+ app using `--webpack=svelte` option:

```
# Rails 5.1+
rails new myapp --webpack=svelte
```

(or run `bundle exec rails webpacker:install:svelte` on a Rails app already setup with Webpacker).

Please play with the [Svelte Tutorial](https://svelte.dev/tutorial/basics) or learn more about its API at https://svelte.dev/docs

## Stimulus

To use Webpacker with [Stimulus](http://stimulusjs.org), create a
new Rails 5.1+ app using `--webpack=stimulus` option:

```
# Rails 5.1+
rails new myapp --webpack=stimulus
```

(or run `bundle exec rails webpacker:install:stimulus` on a Rails app already setup with Webpacker).

Please read [The Stimulus Handbook](https://stimulusjs.org/handbook/introduction) or learn more about its source code at https://github.com/stimulusjs/stimulus

## CoffeeScript

To add [CoffeeScript](http://coffeescript.org/) support,
run `bundle exec rails webpacker:install:coffee` on a Rails app already
setup with Webpacker.

An example `hello_coffee.coffee` file will also be added to your project
in `app/javascript/packs` so that you can experiment with CoffeeScript right away.

## Erb

To add [Erb](https://apidock.com/ruby/ERB) support in your JS templates,
run `bundle exec rails webpacker:install:erb` on a Rails app already
setup with Webpacker.

An example `hello_erb.js.erb` file will also be added to your project
in `app/javascript/packs` so that you can experiment with Erb-flavoured
javascript right away.
