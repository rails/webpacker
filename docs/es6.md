# ES6

## Babel

Webpacker ships with [babel](https://babeljs.io/) - a JavaScript compiler so
you can use next generation JavaScript, today. The Webpacker installer sets up a
standard `babel.config.js` file in your app root, which will work great in most cases
because of [@babel/preset-env](https://github.com/babel/babel/tree/master/packages/babel-preset-env).

Following ES6/7 features are supported out of the box:

* Async/await.
* Object Rest/Spread Properties.
* Exponentiation Operator.
* Dynamic import() - useful for route level code-splitting
* Class Fields and Static Properties.

We have also included [core-js](https://github.com/zloirock/core-js) to polyfill features in the
older browsers.

Don't forget to add these lines into your main entry point:

```js
import "core-js/stable";
import "regenerator-runtime/runtime";
```

## Lazy Loading

Lazy loading is avaible out of the box with split chunks.

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

You can use it in Single File Component as well:

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

### Automatic registration


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

## Module import vs require()

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
