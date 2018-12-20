// Run this example by adding <%= javascript_pack_tag "hello_reason" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
// It will render "Hello Reason!" within a button on the page.

import * as App from "../App.re";

document.addEventListener('DOMContentLoaded', () => {
  const target = document.createElement('div')

  document.body.appendChild(target)
  App.embed(target);
});
