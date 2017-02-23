// Run this example by adding <%= javascript_pack_tag 'vue_todo' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.
// A todo example will be rendered.

import Vue from 'vue'
import App from './app.vue'

document.body.appendChild(document.createElement('hello'))

new Vue({
  el: 'hello',
  template: '<App/>',
  components: { App }
})
