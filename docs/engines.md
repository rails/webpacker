# Using in Rails engines

If the application UI consists of multiple frontend application, you'd probably like to isolate their building too (e.g. if you use different frameworks/versions). Hence we needed our webpack(-er) to be isolated too: separate `package.json`, dev server, compilation process.

You can do this by adding another Webpacker instance to your application.

This guide describes how to do that using [Rails engines](https://guides.rubyonrails.org/engines.html).


## Step 1: create Rails engine.

First, you create a Rails engine (say, `MyEngine`). See the offical [Rails guide](https://guides.rubyonrails.org/engines.html).

## Step 2: install Webpacker within the engine.

There is no built-in tasks to install Webpacker within the engine, thus you have to add all the require files manually (you can copy them from the main app):
- Add `config/webpacker.yml` and `config/webpack/*.js` files
- Add `bin/webpack` and `bin/webpack-dev-server` files
- Add `package.json` with required deps.


## Step 3: configure Webpacker instance.

```ruby
module MyEngine
  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class << self
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end
  end
end
```

## Step 4: Configure dev server proxy.

```ruby
module MyEngine
  class Engine < ::Rails::Engine
    initializer "webpacker.proxy" do |app|
        insert_middleware = begin
                            MyEngine.webpacker.config.dev_server.present?
                          rescue
                            nil
                          end
        next unless insert_middleware

        app.middleware.insert_before(
          0, "Webpacker::DevServerProxy",
          ssl_verify_none: true,
          webpacker: MyEngine.webpacker
        )
      end
  end
end
```

If you have multiple webpackers, you would probably want to run multiple dev servers at a time, and hence be able to configure their setting through env vars (e.g. within a `docker-compose.yml` file):

```yml
# webpacker.yml
# ...
development:
  # ...
  dev_server:
    env_prefix: "MY_ENGINE_WEBPACKER_DEV_SERVER"
    # ...
```

## Step 5: configure helper.

```ruby
require "webpacker/helper"

module MyEngine
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      MyEngine.webpacker
    end
  end
end
```

Now you can use `stylesheet_pack_tag` and `javascript_pack_tag` from within your engine.

## Step 6: rake tasks.

Add Rake task to compile assets in production (`rake my_engine:webpacker:compile`)

```ruby
namespace :my_engine do
  namespace :webpacker do
    desc "Install deps with yarn"
    task :yarn_install do
      Dir.chdir(File.join(__dir__, "../..")) do
        system "yarn install --no-progress --production"
      end
    end

    desc "Compile JavaScript packs using webpack for production with digests"
    task compile: [:yarn_install, :environment] do
      Webpacker.with_node_env("production") do
          if MyEngine.webpacker.commands.compile
            # Successful compilation!
          else
            # Failed compilation
            exit!
          end
      end
    end
  end
end
```

## Step 7: serving compiled packs.

To serve static assets in production via Rails you might need to add a middleware and point it to your engine's webpacker output path:

```ruby
# application.rb

config.middleware.use(
  "Rack::Static",
  urls: ["/my-engine-packs"], root: "my_engine/public"
)
```

**NOTE:** in the example above we assume that your `public_output_path` is set to `my-engine-packs` in your engine's `webpacker.yml`.
 