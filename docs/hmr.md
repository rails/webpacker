### Hot module replacement

Webpacker out-of-the-box supports HMR with `webpack-dev-server` and
you can toggle it by setting `dev_server/hmr` option inside webpacker.yml.

Checkout this guide for more information:

- https://webpack.js.org/configuration/dev-server/#devserver-hot

To support HMR with React you would need to add `react-hot-loader`. Checkout this guide for
more information:

- https://gaearon.github.io/react-hot-loader/getstarted/

**Note:** Don't forget to disable `HMR` if you are not running `webpack-dev-server`
otherwise you will get not found error for stylesheets.
