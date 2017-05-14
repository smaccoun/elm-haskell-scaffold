module Client.Pages.Home.Home exposing (..)

import Html exposing (Html, div, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


type alias Model =
  {viewState: String

  }

model: Model
model = Model "meow"

type Msg = ShowUploadPage | ShowFormFillerPage

update : Msg -> Model -> Model
update msg model =
  case msg of
    ShowUploadPage ->
      {model | viewState = "Show Upload Page"}
    ShowFormFillerPage ->
      {model | viewState = "Show form filler page"}

view : Model -> Html Msg
view model =
  div [style [
    ("display", "flex")
    ,("align-items", "center")
  ]]
  [button [onClick ShowUploadPage] [text "Add Forms"]
  ,div [] [text model.viewState]
  ]