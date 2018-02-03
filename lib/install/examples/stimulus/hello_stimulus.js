// Run this example by adding <%= javascript_pack_tag 'hello_stimulus' %> 
// to app/views/layouts/application.html.erb.
// It will render a <div>Hello Stimulus</div> at the bottom of the page.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

document.addEventListener('DOMContentLoaded', () => {
  var hello = document.createElement('div')
  hello.setAttribute("data-controller", "hello")
  hello.setAttribute("data-target", "hello.output")
  document.body.appendChild(hello)
})