# Developing Webpacker

It's a little trickier for Rails developers to work on the JS code of a project like rails/webpacker. So here are some tips!

## Use some test app
For example, for React on Rails Changes, I'm using [shakacode/react_on_rails_tutorial_with_ssr_and_hmr_fast_refresh](https://github.com/shakacode/react_on_rails_tutorial_with_ssr_and_hmr_fast_refresh).
This directory is the `TEST_APP_DIR`.

## Fork rails/webpacker
Let's call the rails/webpacker directory `WEBPACKER_DIR` which has rails/webpacker's `package.json`.

## Changing the Package
### Setup with Yalc
Use [`yalc`](https://github.com/wclr/yalc) unless you like yak shaving weird errors.
1. In `WEBPACKER_DIR`, run `yalc publish`
2. In `TEST_APP_DIR`, run `yalc link @rails/webpacker`

## Update the Package Code
1. Make some JS change in WEBPACKER_DIR
2. Run `yalc push` and your changes will be pushed to your `TEST_APP_DIR`'s node_modules.
3. You may need to run `yarn` in `TEST_APP_DIR` if you added or removed dependencies of rails/webpacker.

## Updating the Ruby Code

For the Ruby part, just change the gem reference `TEST_APP_DIR`, like:

```ruby
gem "webpacker", path: "../../forks/webpacker"
```
