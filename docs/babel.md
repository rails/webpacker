### Babel

Webpacker ships with [babel](https://babeljs.io/) - a JavaScript compiler so
you can use next generation JavaScript, today. The Webpacker installer sets up a
standard `.babelrc` file in your app root, which will work great in most cases
because of [babel-env-preset](https://github.com/babel/babel-preset-env).

Following ES6/7 features are supported out of the box:

* Async/await.
* Object Rest/Spread Properties.
* Exponentiation Operator.
* Dynamic import() - useful for route level code-splitting
* Class Fields and Static Properties.

We have also included [babel polyfill](https://babeljs.io/docs/usage/polyfill/)
that includes a custom regenerator runtime and core-js.
