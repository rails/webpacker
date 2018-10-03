module Main exposing (..)

import Browser
import Html exposing (Html, h1, text)
import Html.Attributes exposing (style)

-- MODEL

type alias Model =
  {
  }

-- INIT

init : (Model, Cmd Message)
init =
  (Model, Cmd.none)

-- VIEW

view : Model -> Html Message
view model =
  -- The inline style is being used for example purposes in order to keep this example simple and
  -- avoid loading additional resources. Use a proper stylesheet when building your own app.
  h1 [style "display" "flex", style "justify-content" "center"]
     [text "Hello Elm!"]

-- MESSAGE

type Message
  = None

-- UPDATE

update : Message -> Model -> (Model, Cmd Message)
update message model =
  (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none

-- MAIN

main : Program (Maybe {}) Model Message
main =
  Browser.element
    {
      init = always init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
