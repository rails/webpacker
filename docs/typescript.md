# TypeScript

## Installation

1. Run the TypeScript installer

```bash
bundle exec rails webpacker:install:typescript
```

After that, a new file called `hello_typescript.ts` will be present in your `packs` directory (or rather the `source_entry_path` of your `webpacker.yml` configuration). You're now ready to write TypeScript. 

## (Optional) Adding Compile-Time Type Checking

The default installation only transpiles your TypeScript code using Babel. If you would like to enable type checking as part of the Webpack compilation process (i.e. fail the build if there are TS errors), you can do the following:

1. Install the Fork TS Checker Webpack Plugin

    ```sh
    yarn add --dev fork-ts-checker-webpack-plugin
    ```

2. Then add it to your development environment config in `config/webpack/development.js`

    ```js
    const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");
    const path = require("path");

    environment.plugins.append(
      "ForkTsCheckerWebpackPlugin",
      new ForkTsCheckerWebpackPlugin({
        typescript: {
          configFile: path.resolve(__dirname, "../../tsconfig.json"),
        },
        async: false,
      })
    );
    ```

    If you are `fork-ts-checker-webpack-plugin` older than 5.0, the `tsconfig` option also needs to be specified:

    ```js
    const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");
    const path = require("path");

    environment.plugins.append(
      "ForkTsCheckerWebpackPlugin",
      new ForkTsCheckerWebpackPlugin({
        // this is a relative path to your project's TypeScript config
        tsconfig: path.resolve(__dirname, "../../tsconfig.json"),
        // non-async so type checking will block compilation
        async: false,
      })
    );
    ```

## Upgrading to 5.1

If you update your App to `webpacker >= 5.1` and had TypeScript installed before, you need to add some new/remove some old configurations:

1. Remove old packages:
    - `yarn remove ts-loader`

2. Add new packages:
    - `yarn add @babel/preset-typescript`

3. Remove old configuration files: 
    - Delete this file: `config/webpack/loaders/typescript.js`

4. Remove the following lines from `config/webpack/environment.js`:
    - `const typescript = require('./loaders/typescript')`
    - `environment.loaders.prepend('typescript', typescript)`

5. Add the TypeScript preset to your `babel.config.js`:
    - This line `['@babel/preset-typescript', { 'allExtensions': true, 'isTSX': true }]` has to be added as the last item to the `presets` array in your `babel.config.js`

### Upgrading to 5.1 for Vue users

1. Remove old packages:
    - `yarn remove ts-loader pnp-webpack-plugin`

2. Follow point 3 and 4 from the `TypeScript with Vue components` section

## TypeScript with React

1. Setup react using Webpacker [react installer](../README.md#react). Then run the TypeScript installer

```bash
bundle exec rails webpacker:install:typescript
```

2. Rename the generated `hello_react.js` to `hello_react.tsx`. Make the file valid TypeScript and
now you can use TypeScript, JSX with React.

## TypeScript with Vue components

1. Setup Vue using the Webpacker [Vue installer](../README.md#vue). Then run the TypeScript installer

```bash
bundle exec rails webpacker:install:typescript
```

2. Rename generated `hello_vue.js` to `hello_vue.ts`.
3. Install the right Babel preset: `yarn add babel-preset-typescript-vue`
4. Change the generated `babel.config.js` from

```js
["@babel/preset-typescript", { "allExtensions": true, "isTSX": true }]
```

to

```js
["babel-preset-typescript-vue", { "allExtensions": true, "isTSX": true }]
```

and now you can use `<script lang="ts">` in your `.vue` component files. See [the babel-preset-typescript-vue docs](https://www.npmjs.com/package/babel-preset-typescript-vue) for more info.

## HTML templates with TypeScript and Angular

After you have installed Angular using `bundle exec rails webpacker:install:angular`
you would need to follow these steps to add HTML templates support:

1. Use `yarn` to add html-loader

```bash
yarn add html-loader
```

2. Add html-loader to `config/webpack/environment.js`

```js
environment.loaders.append('html', {
  test: /\.html$/,
  use: [{
    loader: 'html-loader',
    options: {
      minimize: true,
      removeAttributeQuotes: false,
      caseSensitive: true,
      customAttrSurround: [ [/#/, /(?:)/], [/\*/, /(?:)/], [/\[?\(?/, /(?:)/] ],
      customAttrAssign: [ /\)?\]?=/ ]
    }
  }]
})
```

3. Add `.html` to `config/webpacker.yml`

```yml
  extensions:
    - .elm
    - .coffee
    - .html
```

4. Setup a custom `d.ts` definition

```ts
// app/javascript/hello_angular/html.d.ts

declare module "*.html" {
  const content: string
  export default content
}
```

5. Add a template.html file relative to `app.component.ts`

```html
<h1>Hello {{name}}</h1>
```

6. Import template into `app.component.ts`

```ts
import { Component } from '@angular/core'
import templateString from './template.html'

@Component({
  selector: 'hello-angular',
  template: templateString
})

export class AppComponent {
  name = 'Angular!'
}
```

That's all. Voila!
