# Webpack Dev Server


## HTTPS

If you're using the `webpack-dev-server` in development, you can serve your packs over HTTPS
by setting the `https` option for `webpack-dev-server` to `true` in `config/webpacker.yml`,
then start the dev server as usual with `./bin/webpack-dev-server`.

Please note that the `webpack-dev-server` will use a self-signed certificate,
so your web browser will display a warning/exception upon accessing the page. If you get
`https://localhost:3035/sockjs-node/info?t=1503127986584 net::ERR_INSECURE_RESPONSE`
in your console, simply open the link in your browser and accept the SSL exception.
Now if you refresh your rails view everything should work as expected.


## HOT module replacement

Webpacker out-of-the-box supports HMR with `webpack-dev-server` and
you can toggle it by setting `dev_server/hmr` option inside webpacker.yml.

Checkout this guide for more information:

- https://webpack.js.org/configuration/dev-server/#devserver-hot

To support HMR with React you would need to add `react-hot-loader`. Checkout this guide for
more information:

- https://gaearon.github.io/react-hot-loader/getstarted/

**Note:** Don't forget to disable `HMR` if you are not running `webpack-dev-server`
otherwise you will get not found error for stylesheets.
