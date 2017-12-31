// Run this example by adding <%= javascript_pack_tag 'hello_stimulus' %> 
// to app/views/layouts/application.html.erb.
// It will render an input and button which prints to your console.

import { Application } from "stimulus"
import { autoload } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
autoload(context, application)

//You may replace the code below with its equivalent html code 
document.addEventListener('DOMContentLoaded', () => {
  var i = document.createElement('input')
  i.type = "text"
  i.setAttribute("data-target", "hello.name")
  var b = document.createElement('button')
  b.innerText = "Greet"
  b.setAttribute("data-action", "click->hello#greet")
  var h = document.createElement('div')
  h.setAttribute("data-controller", "hello")
  h.appendChild(i)
  h.appendChild(b)
  document.body.appendChild(h)
})