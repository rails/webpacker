// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello Vue</div> at the bottom
// of the page.

import Vue from 'vue'

document.addEventListener("DOMContentLoaded", e => {
  document.body.appendChild(document.createElement('hello'))
  new Vue({
    el: 'hello',
    data: { name: "Vue" },
    render(createElement) {
      return createElement('div',{},["Hello " + this.name])
    },
  });
})
