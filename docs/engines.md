# Using in Rails engines

If the application UI consists of multiple frontend application, you'd probably like to isolate their building too (e.g. if you use different frameworks/versions). Hence we needed our webpack(-er) to be isolated too: separate `package.json`, dev server, compilation process.

You can do this by adding another Webpacker instance to your application.

This guide describes how to do that using [Rails engines](https://guides.rubyonrails.org/engines.html).


## Step 1: create Rails engine.

First, you create a Rails engine (say, `MyEngine`). See the official [Rails guide](https://guides.rubyonrails.org/engines.html).

## Step 2: install Webpacker within the engine.

There is no built-in tasks to install Webpacker within the engine, thus you have to add all the require files manually (you can copy them from the main app):
- Add `config/webpacker.yml` and `config/webpack/*.js` files
- Add `bin/webpack` and `bin/webpack-dev-server` files
- Add `package.json` with required deps.


## Step 3: configure Webpacker instance.

- File `lib/my_engine.rb`

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

- File `lib/my_engine/engine.rb`

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
          0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
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

- File `app/helpers/my_engine/application_helper.rb`

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

- File `my_engine_rootlib/tasks/my_engine_tasks.rake`

```ruby
def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new(STDOUT)
  yield
ensure
  Webpacker.logger = old_logger
end


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
        ensure_log_goes_to_stdout do
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
end

def yarn_install_available?
  rails_major = Rails::VERSION::MAJOR
  rails_minor = Rails::VERSION::MINOR

  rails_major > 5 || (rails_major == 5 && rails_minor >= 1)
end

def enhance_assets_precompile
  # yarn:install was added in Rails 5.1
  deps = yarn_install_available? ? [] : ["my_engine:webpacker:yarn_install"]
  Rake::Task["assets:precompile"].enhance(deps) do
    Rake::Task["my_engine:webpacker:compile"].invoke
  end
end

# Compile packs after we've compiled all other assets during precompilation
skip_webpacker_precompile = %w(no false n f).include?(ENV["WEBPACKER_PRECOMPILE"])

unless skip_webpacker_precompile
  if Rake::Task.task_defined?("assets:precompile")
    enhance_assets_precompile
  else
    Rake::Task.define_task("assets:precompile" => "my_engine:webpacker:compile")
  end
end
```

## Step 7: serving compiled packs.

There are two approaches on serving compiled assets.

### Put engine's assets to the root app's public/ folder

You can serve engine's assets using the main app's static files server which serves files from `public/` folder.

For that you must configure your engine's webpacker to put compiled assets to the app's `public/` folder:

```yml
# my_engine/config/webpacker.yml
default: &default
  # ...
  # public_root_path could be used to override the path to `public/` folder
  # (relative to the engine root)
  public_root_path: ../public
  # use a different sub-folder name
  public_output_path: my-engine-packs
```

### Use a separate middleware

To serve static assets from the engine's `public/` folder you must add a middleware and point it to your engine's webpacker output path:

```ruby
# application.rb

config.middleware.use(
  Rack::Static,
  urls: ["/my-engine-packs"], root: "my_engine/public"
)
```

**NOTE:** in the example above we assume that your `public_output_path` is set to `my-engine-packs` in your engine's `webpacker.yml`.
