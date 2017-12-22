# Typescript


## Typescript with React

1. Setup react using Webpacker [react installer](#react). Then run the typescript installer

```bash
bundle exec rails webpacker:install:typescript
yarn add @types/react @types/react-dom
```

2. Rename the generated `hello_react.js` to `hello_react.tsx`. Make the file valid typescript and
now you can use typescript, JSX with React.


## HTML templates with Typescript and Angular

After you have installed Angular using `bundle exec rails webpacker:install:angular`
you would need to follow these steps to add HTML templates support:

1. Use `yarn` to add html-loader

```bash
yarn add html-loader
```

2. Add html-loader to `config/webpack/environment.js`

```js
environment.loaders.set('html', {
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
