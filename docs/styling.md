## Linking Styles, Images and Fonts

Static assets like images, fonts and stylesheets support is enabled out-of-box
and you can link them into your javascript app code and have them
compiled automatically.


### Within your JS app

```sass
// app/javascript/hello_react/styles/hello-react.sass

.hello-react
  padding: 20px
  font-size: 12px
```

```js
// React component example
// app/javascripts/packs/hello_react.jsx

import React from 'react'
import helloIcon from '../hello_react/images/icon.png'
import '../hello_react/styles/hello-react'

const Hello = props => (
  <div className="hello-react">
    <img src={helloIcon} alt="hello-icon" />
    <p>Hello {props.name}!</p>
  </div>
)
```


### Inside views

Under the hood webpack uses
[extract-text-webpack-plugin](https://github.com/webpack-contrib/extract-text-webpack-plugin) plugin to extract all the referenced styles within your app and compile it into
a separate `[pack_name].css` bundle so that in your view you can use the
`stylesheet_pack_tag` helper.

```erb
<%= stylesheet_pack_tag 'hello_react' %>
```

You can also link js/images/styles used within your js app in views using
`asset_pack_path` helper. This helper is useful in cases where you just want to
create a `<link rel="prefetch">` or `<img />` for an asset.

```erb
<%= asset_pack_path 'hello_react.css' %>
<%# => "/packs/hello_react.css" %>

<img src="<%= asset_pack_path 'calendar.png' %>" />
<% # => <img src="/packs/calendar.png" /> %>
```


### From node modules folder

You can also import styles from `node_modules` using the following syntax.
Please note that your styles will always be extracted into `[pack_name].css`:

```sass
// app/javascript/app-styles.sass
// ~ to tell webpack that this is not a relative import:

@import '~@material/animation/mdc-animation'
@import '~bootstrap/dist/css/bootstrap'
```

```js
// Your main app pack
// app/javascript/packs/app.js

import '../app-styles'
```

```erb
<%# In your views %>

<%= javascript_pack_tag 'app' %>
<%= stylesheet_pack_tag 'app' %>
```

### Post-Processing CSS

Webpacker out-of-the-box provides CSS post-processing using
[postcss-loader](https://github.com/postcss/postcss-loader)
and the installer sets up a standard `.postcssrc.yml`
file in your app root with standard plugins.

```yml
plugins:
  postcss-smart-import: {}
  postcss-cssnext: {}
```
