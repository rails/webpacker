# Docker

To setup webpacker with a dockerized Rails application.

First, add a new service for webpacker in docker-compose.yml:

```Dockerfile
version: '3'
services:
  webpacker:
    build: .
    environment:
      - NODE_ENV=development
      - RAILS_ENV=development
      - WEBPACKER_DEV_SERVER_HOST=0.0.0.0
    command: ./bin/webpack-dev-server
    volumes:
      - .:/webpacker-example-app
    ports:
      - '3035:3035'
```

add nodejs and yarn as dependencies in Dockerfile,

```dockerfile
FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y build-essential nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && curl -o- -L https://yarnpkg.com/install.sh | bash

# Rest of the commands....
```

Please note: if using `assets:precompile` in the Dockerfile or have issues with the snippet above then try:

```dockerfile
FROM ruby:2.4.1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
 && apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/* \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -y yarn && rm -rf /var/lib/apt/lists/*

# Rest of the commands....
```

then add the webpacker host name environment variable to the web/app service:

```Dockerfile
  web:
    build:
      context: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/usr/src/app
    ports:
      - "3000:3000"
    environment:
      - WEBPACKER_DEV_SERVER_HOST=webpacker
```

Lastly, rebuild your container:

```bash
docker-compose up --build
```
