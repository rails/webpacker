# Assets


Static assets like images and fonts support is enabled out-of-box
and you can link them into your JavaScript app code and have them
compiled automatically.


## Import from node modules

You can also import styles from `node_modules` using the following syntax.
Please note that your styles will always be extracted into `[pack_name].css`:

```sass
// app/javascript/styles.sass
// ~ to tell webpack that this is not a relative import:

@import '~@material/animation/mdc-animation'
@import '~bootstrap/dist/css/bootstrap'
```

```js
// Your main app pack
// app/javascript/packs/app.js

import '../styles'
```

```erb
<%# In your views %>

<%= javascript_pack_tag 'app' %>
<%= stylesheet_pack_tag 'app' %>
```


## Import from Sprockets using helpers

It's possible to link to assets that have been precompiled by Sprockets. Add the `.erb` extension to your JavaScript file, then you can use Sprockets' asset helpers:

```erb
<%# app/javascript/my_pack/example.js.erb %>

<% helpers = ActionController::Base.helpers %>
const railsImagePath = "<%= helpers.image_path('rails.png') %>"
```

This is enabled by the `rails-erb-loader` loader rule in `config/webpack/loaders/erb.js`.


## Using babel module resolver

You can also use [babel-plugin-module-resolver](https://github.com/tleunen/babel-plugin-module-resolver) to reference assets directly from `app/assets/**`

```bash
yarn add babel-plugin-module-resolver
```

Specify the plugin in your `babel.config.js` with the custom root or alias. Here's an example:

```js
{
  plugins: [
    [require("babel-plugin-module-resolver").default, {
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
// Note: we don't have to do any ../../ jazz

import FooImage from 'assets/images/foo-image.png'
import 'assets/stylesheets/bar'
```


## Link in your Rails views

You can also link `js/images/styles/fonts` used within your js app in views using
`asset_pack_path` and `image_pack_tag` helpers. These helpers are useful in cases where you just want to
create a `<link rel="prefetch">` or `<img />` for an asset.

```yml
app/javascript:
  - packs
    - app.js
  - images
    - calendar.png
```

```js
// app/javascript/packs/app.js (or any of your packs)

// import all image files in a folder:
require.context('../images', true)
```

```erb
<%# Rails view, for example app/views/layouts/application.html.erb %>

<img src="<%= asset_pack_path 'media/images/calendar.png' %>" />
<% # => <img src="/packs/media/images/calendar-k344a6d59eef8632c9d1.png" /> %>

<%= image_pack_tag 'media/images/calendar.png' %>
<% # => <img src="/packs/media/images/calendar-k344a6d59eef8632c9d1.png" /> %>

<%# no path resolves to default 'images' folder: %>
<%= image_pack_tag 'calendar.png' %>
<% # => <img src="/packs/media/images/calendar-k344a6d59eef8632c9d1.png" /> %>
```

Note you need to add a `media/` prefix (not `/media/`) to any subfolder structure you might have in `app/javascript`. See more examples in the [tests](https://github.com/rails/webpacker/blob/0b86cadb5ed921e2c1538382e72a236ec30a5d97/test/helper_test.rb#L37).
