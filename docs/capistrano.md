# Capistrano

## Assets compiling on every deployment even if JavaScript and CSS files are not changed

Make sure you have `public/packs` and `node_modules` in `:linked_dirs`

```ruby
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/packs", ".bundle", "node_modules"
```
