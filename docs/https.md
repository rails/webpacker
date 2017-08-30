### HTTPS in development

If you're using the `webpack-dev-server` in development, you can serve your packs over HTTPS
by setting the `https` option for `webpack-dev-server` to `true` in `config/webpacker.yml`,
then start the dev server as usual with `./bin/webpack-dev-server`.

Please note that the `webpack-dev-server` will use a self-signed certificate,
so your web browser will display a warning/exception upon accessing the page. If you get
`https://localhost:3035/sockjs-node/info?t=1503127986584 net::ERR_INSECURE_RESPONSE`
in your console, simply open the link in your browser and accept the SSL exception.
Now if you refresh your rails view everything should work as expected.
