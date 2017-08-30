# Testing


## Lazy compilation

Webpacker lazily compiles assets in test env so you can write your tests without any extra
setup and everything will just work out of the box.

Here is a sample system test case with hello_react example component:

```js
// Example react component

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const Hello = props => (
  <div>Hello David</div>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Hello />,
    document.body.appendChild(document.createElement('div')),
  )
})
```

```erb
<%# views/pages/home.html.erb %>

<%= javascript_pack_tag "hello_react" %>
```

```rb
# Tests example react component
require "application_system_test_case"
class HomesTest < ApplicationSystemTestCase
  test "can see the hello message" do
    visit root_url
    assert_selector "h5", text: "Hello! David"
  end
end
```
