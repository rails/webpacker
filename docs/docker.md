# Docker

To setup webpacker with a dockerized Rails application is very trivial.

First, add a new service for webpacker in docker-compose.yml:

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

Add nodejs and yarn as dependencies in Dockerfile,

```dockerfile
FROM ruby:2.4.1
RUN apt-get update -qq
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
```

and create an env file to load environment variables from:

```env
NODE_ENV=development
RAILS_ENV=development
WEBPACKER_DEV_SERVER_HOST: 0.0.0.0
```
