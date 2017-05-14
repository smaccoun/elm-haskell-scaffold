module Client.Pages.Home.Home exposing (..)

import Html exposing (Html, div, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


type alias Model =
  {viewState: String

  }

model: Model
model = Model "meow"

type Msg = ShowSomething

update : Msg -> Model -> Model
update msg model =
  case msg of
    ShowSomething ->
      {model | viewState = "Something!"}

view : Model -> Html Msg
view model =
  div [style [
    ("display", "flex")
    ,("align-items", "center")
  ]]
  [button [onClick ShowSomething] [text "Show Me Something"]
  ,div [] [text model.viewState]
  ]