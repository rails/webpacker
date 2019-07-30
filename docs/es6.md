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

## Dynamic/Lazy Chunk Loading

For this section, you need Webpack and Webpacker 4. Then enable `SplitChunks` as it is explained in [docs/webpack](webpack.md).

[Dynamic code splitting](https://webpack.js.org/guides/code-splitting#dynamic-imports) enables you to conditionally request/run only the JS that you need. For example, if your site has a `searchBarComponent` on every page, you can reduce the page overhead by deferring the request for the `searchBarComponent` code until after the page has loaded, until the user has scrolled it into view, or until the user has clicked on an element.

```js
 function loadSearchBarComponent() {
   return import(/* webpackChunkName: "searchBarComponent" */ './pathTo/searchBarComponent')
 }
```

The comment you see above (`/* webpackChunkName */`) is not arbitrary, it is one of webpacks [magic comments](https://webpack.js.org/api/module-methods/#magic-comments). They can be used to fine-tune `import()` with settings such as `defer` or `prefetch`.

**Warning**: You should not attempt to dynamically load anything from your `packs/` folder. Instead, try to make your `pack` scripts a hub from which you dynamically load `non-pack` scripts.

- [Docs for using magic comments](https://webpack.js.org/api/module-methods/#magic-comments)
- [Docs for configuring `splitChunks` in webpacker](https://github.com/rails/webpacker/blob/master/docs/webpack.md#add-splitchunks-webpack-v4).
- [Docs for using dynamic `import()`](https://webpack.js.org/guides/code-splitting#dynamic-imports).

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
