# To webpacker v6 from v5

This guide aims to help you migrating to webpacker 6.

## Preparation

- Rename `config/webpack` to `config/webpack_old`
- Rename `config/webpacker.yml` to `config/webpacker_old.yml`
- Upgrade webpacker

  ```ruby
  # Gemfile
  gem 'webpacker', '~> 6.x'
  ```

  ```
  bundle
  ```

  ```bash
  yarn add @rails/webpacker@next
  ```

  ```bash
  bundle exec rails webpacker:install
  ```

- Change `javascript_pack_tag` and `stylesheet_pack_tag` to `javascript_packs_with_chunks_tag` and
  `stylesheet_packs_with_chunks_tag`

- If you are using any integrations like css, react or typescript. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.0
