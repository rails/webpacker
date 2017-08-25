// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head
// of your layout file, like app/views/layouts/application.html.erb.
// All it does is render <div>Hello React</div> at the bottom of the page with an image.

import React from 'react'
import ReactDOM from 'react-dom'
import HelloReact from '../hello_react'

// Create a DOM node to mount the app
const nodeElement = document.createElement('div')
nodeElement.id = 'react-app'
const node = document.body.appendChild(nodeElement)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<HelloReact />, node)
})

// Hot Module Replacement API
if (module.hot) {
  module.hot.accept('../hello_react', () => {
    /* eslint global-require: 0 */
    const NextApp = require('../hello_react').default
    ReactDOM.render(<NextApp />, node)
  })
}
