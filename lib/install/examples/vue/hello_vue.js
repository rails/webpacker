/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %>
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import App from './app.vue'

document.addEventListener('DOMContentLoaded', () => {
  document.body.appendChild(document.createElement('hello'))
  const app = new Vue({
    el: 'hello',
    template: '<App/>',
    components: { App }
  })

  console.log(app)
})
