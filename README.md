# Webpacker

Webpacker makes it easy to use the JavaScript preprocessor and bundler [Webpack](http://webpack.github.io)
to manage application-like JavaScript in Rails. It coexists with the asset pipeline,
as the purpose is only to use Webpack for app-like JavaScript, not images, css, or
even JavaScript Sprinkles (that all continues to live in app/assets).

It's designed to work with Rails 5.1+ and makes use of the Yarn dependency management
that's been made default from that version forward.
It's also currently compatible with Rails 5.0 stable but there's absolutely no warranty
it will still be in the future.
You can either make use of Webpacker during setup of a new application with `--webpack`
or you can add the gem and run `bin/rails webpacker:install` in an existing application.


## Binstubs

Webpacker ships with two binstubs: `./bin/webpack` and `./bin/webpack-watcher`. They're both thin wrappers
around the standard webpack.js executable, just to ensure that the right configuration
file is loaded and the node_modules from vendor are used.

In development, you'll need to run `./bin/webpack-watcher` in a separate terminal from
`./bin/rails server` to have your `app/javascript/packs/*.js` files compiled as you make changes.
If you'd rather not have to run the two processes separately by hand, you can use
[Foreman](http://ddollar.github.io/foreman/).


## Configuration

Webpacker gives you a default set of configuration files for development and production. They
all live together with the shared points in `config/webpack/*.js`. By default, you shouldn't have to
make any changes for a basic setup out the box. But this is where you do go if you need something
more advanced.

The configuration for what Webpack is supposed to compile by default rests on the convention that
every file in `app/javascript/packs/*` should be turned into their own output files (or entry points,
as Webpack calls it).

Let's say you're building a calendar. Your structure could look like this:

```erb
<%# app/views/layout/application.html.erb %>
<%= javascript_pack_tag 'calendar' %>
```

```js
// app/javascript/packs/calendar.js
require('calendar')
```

```
app/javascript/calendar/index.js // gets loaded by require('calendar')
app/javascript/calendar/components/grid.jsx
app/javascript/calendar/models/month.js
```

But it could also look a million other ways. The only convention that Webpacker enforces is the
one where entry points are automatically configured by the files in `app/javascript/packs`.


## Deployment

To compile all the packs during deployment, you can use the `rails webpacker:compile` command. This
will invoke the production configuration, which includes digesting. The `javascript_pack_tag` helper
method will automatically insert the correct digest when run in production mode. Just like the asset
pipeline does it.


## Ready for React

To use Webpacker with React, just create a new app with `rails new myapp --webpack=react` (or run `rails webpacker:install:react` on a Rails 5.1 app already setup with webpack), and all the relevant dependencies
will be added via yarn and changes to the configuration files made. Now you can create JSX files and
have them properly compiled automatically.


## Work left to do

- Make asset pipeline digests readable from webpack, so you can reference images etc
- Consider chunking setup
- Consider on-demand compiling with digests when digesting=true
- I'm sure a ton of other shit

## License
Webpacker is released under the [MIT License](http://www.opensource.org/licenses/MIT).
