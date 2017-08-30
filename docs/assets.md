## Link sprocket assets

### Using helpers

It's possible to link to assets that have been precompiled by sprockets. Add the `.erb` extension to your javascript file, then you can use Sprockets' asset helpers:

```erb
<%# app/javascript/my_pack/example.js.erb %>

<% helpers = ActionController::Base.helpers %>
var railsImagePath = "<%= helpers.image_path('rails.png') %>"
```

This is enabled by the `rails-erb-loader` loader rule in `config/webpack/loaders/erb.js`.


### Using babel module resolver

You can also use [babel-plugin-module-resolver](https://github.com/tleunen/babel-plugin-module-resolver) to reference assets directly from `app/assets/**`

```bash
yarn add babel-plugin-module-resolver
```

Specify the plugin in your `.babelrc` with the custom root or alias. Here's an example:

```json
{
  "plugins": [
    ["module-resolver", {
      "root": ["./app"],
      "alias": {
        "assets": "./assets"
      }
    }]
  ]
}
```

And then within your javascript app code:

```js
// Note: we don't have do any ../../ jazz

import FooImage from 'assets/images/foo-image.png'
import 'assets/stylesheets/bar'
```
