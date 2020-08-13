# Props

How do you pass props from your view to your JavaScript component? Here you go.

## React
See [docs/react.md](./react.md#props-hydration-and-server-side-rendering-ssr).

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
        test: 'This will display: '
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


## Elm

Just like with other implementations, we'll render our data inside a `data`
attribute:

```erb
<%= content_tag :div,
  id: "hello-elm",
  data: {
    message: "Hello",
    name: "David"
  }.to_json do %>
<% end %>
```

We parse the JSON data and pass it to Elm as flags:

```js
import Elm from '../Main'

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-elm')
  const data = JSON.parse(node.getAttribute('data'))
  Elm.Main.embed(node, data)
})
```

Defining `Flags` as a `type alias`, we instruct Elm to demand flags `message`
and `name` of type `String` on initialization.

Using `programWithFlags` we bring all the pieces together:


```elm
module Main exposing (..)

import Html exposing (Html, programWithFlags, h1, text)
import Html.Attributes exposing (style)


-- MODEL


type alias Flags =
    { message : String
    , name : String
    }


type alias Model =
    { message : String
    , name : String
    }


type Msg
    = NoOp



-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        { message, name } =
            flags
    in
        ( Model message name, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    h1 [ style [ ( "display", "flex" ), ( "justify-content", "center" ) ] ]
        [ text (model.message ++ ", " ++ model.name ++ "!") ]



-- MAIN


main : Program Flags Model Msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }

```
