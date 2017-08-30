# Props


## React

If you need more advanced React-integration, like server rendering, redux, or react-router, see [shakacode/react_on_rails](https://github.com/shakacode/react_on_rails), [react-rails](https://github.com/reactjs/react-rails), and [webpacker-react](https://github.com/renchap/webpacker-react).

If you're not concerned with view helpers to pass props or server rendering, can do it yourself:

```erb
<%# views/layouts/application.html.erb %>

<%= content_tag :div,
  id: "hello-react",
  data: {
    message: 'Hello!',
    name: 'David'
}.to_json do %>
<% end %>
```

```js
// app/javascript/packs/hello_react.js

const Hello = props => (
  <div className='react-app-wrapper'>
    <img src={clockIcon} alt="clock" />
    <h5 className='hello-react'>
      {props.message} {props.name}!
    </h5>
  </div>
)

// Render component with data
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))

  ReactDOM.render(<Hello {...data} />, node)
})
```


## Vue

Add the data as attributes in the element you are going to use (or any other element for that matter).

```erb
<%= content_tag :div,
  id: "hello-vue",
  data: {
    message: "Hello!",
    name: "David"
  }.to_json do %>
<% end %>
```

This should produce the following HTML:

```html
<div id="hello-vue" data="{&quot;message&quot;:&quot;Hello!&quot;,&quot;name&quot;:&quot;David&quot;}"></div>
```

Now, modify your Vue app to expect the properties.

```html
<template>
  <div id="app">
    <p>{{test}}{{message}}{{name}}</p>
  </div>
</template>

<script>
  export default {
    // A child component needs to explicitly declare
    // the props it expects to receive using the props option
    // See https://vuejs.org/v2/guide/components.html#Props
    props: ["message","name"],
    data: function () {
      return {
          test: 'This will display: ',
      }
    }
  }
</script>

<style>
</style>

```

```js
document.addEventListener('DOMContentLoaded', () => {
  // Get the properties BEFORE the app is instantiated
  const node = document.getElementById('hello-vue')
  const props = JSON.parse(node.getAttribute('data'))

  // Render component with props
  new Vue({
    render: h => h(App, { props })
  }).$mount('#hello-vue');
})
```

You can follow same steps for Angular too.
