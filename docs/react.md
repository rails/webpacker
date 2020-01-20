# React

If you need more advanced React-integration, like server-side rendering, SSR with react-router, SSR with code splitting, then you should consider these gems:

| Gem | Props Hydration | Server-Side-Rendering (SSR) | SSR with HMR | SSR with React-Router | SSR with Code Splitting |
| --- | --------------- | --- | --------------------- | ----------------------| ------------------------|
| [shakacode/react_on_rails](https://github.com/shakacode/react_on_rails) | ✅ | ✅ | ✅ | ✅ | ✅ |
| [react-rails](https://github.com/reactjs/react-rails)  | ✅ | ✅ |  | | | |
| [webpacker-react](https://github.com/renchap/webpacker-react) | ✅ | | | | | |

## HMR and React Hot Reloading

Before turning HMR on, consider upgrading to latest stable gems and packages:
https://github.com/rails/webpacker#upgrading

First, check that the `hmr` option is `true` in your `config/webpacker.yml` file.

```diff
development:
  # ...
  dev_server:
-    hmr: false
+    hmr: true
# ...
```

The basic setup will have HMR working with the default webpacker setup. However, the basic will cause a full page refresh each time you save a file.

Webpack's HMR allows replacement of modules in-place without reloading the browser.

To do this next part, you have two options:

1. Follow the deprecated steps at [github.com/gaearon/react-hot-loader](https://github.com/gaearon/react-hot-loader).
2. Follow the steps at [github.com/pmmmwh/react-refresh-webpack-plugin](https://github.com/pmmmwh/react-refresh-webpack-plugin).


### React Hot Loader (Deprecated)

1. Add the `react-hot-loader` npm package.
  ```sh
  yarn add --dev react-hot-loader @hot-loader/react-dom
  ```

  If you are using React hooks:
  ```sh
  yarn add --dev "@hot-loader/react-dom"
  ```

2. Add changes like this to your entry points

```diff
// app/javascript/app.jsx

import React from 'react';
+ import { hot } from 'react-hot-loader/root';

const App = () => <SomeComponent(s) />

- export default App;
+ export default hot(App);
```

3. Adjust your webpack configuration for development so that `sourceMapContents` option for the sass
loader is `false`

```diff
// config/webpack/development.js

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

// allows for editing sass/scss files directly in browser
+ if (!module.hot) {
+   environment.loaders.get('sass').use.find(item => item.loader === 'sass-loader').options.sourceMapContents = false
+ }
+ 
module.exports = environment.toWebpackConfig()
```

4. Adjust your `config/webpack/environment.js` for a 

```diff
// config/webpack/environment.js

// ...

// Fixes: React-Hot-Loader: react-🔥-dom patch is not detected. React 16.6+ features may not work.
// https://github.com/gaearon/react-hot-loader/issues/1227#issuecomment-482139583
+ environment.config.merge({ resolve: { alias: { 'react-dom': '@hot-loader/react-dom' } } });

module.exports = environment;
```

### React Refresh Plugin

_Docs coming soon._ 

## Hydration of Props

If you're not concerned with view helpers to pass props or server-side rendering, you can do it like this:

```erb
<%# views/layouts/application.html.erb %>

<%= content_tag :div,
  id: "hello-react",
  data: {
    message: 'Hello!',
    name: 'David'
}.to_json do %>
<% end %>
```

```js
// app/javascript/packs/hello_react.js

const Hello = props => (
  <div className='react-app-wrapper'>
    <img src={clockIcon} alt="clock" />
    <h5 className='hello-react'>
      {props.message} {props.name}!
    </h5>
  </div>
)

// Render component with data
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))

  ReactDOM.render(<Hello {...data} />, node)
})
```
