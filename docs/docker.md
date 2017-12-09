# Docker

To setup webpacker with a dockerized Rails application is very trivial.

First, add a new service for webpacker:

```Dockerfile
version: '3'
services:
  webpacker:
    build: .
    env_file:
      - '.env.docker'
    command: bundle exec webpack-dev-server
    volumes:
      - .:/webpacker-example-app
    ports:
      - '3035:3035'
```

and create an env file to load environment variables from:

```env
NODE_ENV=development
RAILS_ENV=development
WEBPACKER_DEV_SERVER_HOST: 0.0.0.0
```
