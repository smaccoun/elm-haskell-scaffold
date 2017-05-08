module Client.Login.Login exposing (..)

import Html exposing (Html, div, input, text, button)
import Html.Attributes exposing (style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Material exposing (Msg)
import Material.Textfield as Textfield exposing (label, floatingLabel, password)
import Material.Options as Options exposing (onInput, css)
import Material.Button as Button
import Material.Color as Color
import Material.Scheme exposing (top)

import Server.API.Queries.Authentication as Server exposing (loginUser)

type alias Model =
  {email: String
  ,password: String
  ,mdl : Material.Model
  }


initModel: Material.Model -> Model
initModel mdlModel = Model "" "" mdlModel


--UPDATE
type Msg =
    Mdl (Material.Msg Msg)
  | InputPassword String
  | InputEmail String
  | Submit String String

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg_ ->
        Material.update Mdl msg_ model
    InputEmail email ->
      ({model | email = email}, Cmd.none)
    InputPassword password ->
      ({model | password = password}, Cmd.none)
    Submit email password ->
      (model, Cmd.none)

--VIEW

view: Model -> Html Msg
view model =
  div [style [("width", "240px")
  , ("position", "fixed")
  , ("top", "calc(50vh-50px)")
  , ("left", "calc(50vw - 120px)")
  ]]
  [
    loginCardContent model
  ]

loginCardContent: Model -> Html Msg
loginCardContent model =
  div [ style [ ( "display", "flex" )
  , ( "flex-direction", "column" )
  , ( "margin", "8px" )
  , ("padding", "10px 15px 10px 15px")
  ] ]
      [ Textfield.render Mdl
          [ 10, 0 ]
          model.mdl
          [ Textfield.label "Enter email"
          , Textfield.floatingLabel
          , Textfield.email
          , Options.onInput InputEmail
          ]
          []
      , Textfield.render Mdl
          [ 10, 1 ]
          model.mdl
          [ Textfield.label "Password"
          , Textfield.floatingLabel
          , Textfield.password
          , Options.onInput InputPassword
          ]
          []

      , Button.render Mdl [0] model.mdl
      [ Button.raised
      , Button.ripple
      , Options.onClick (Submit model.email model.password)
      ]
      [ text "Login" ]
      ]
      |> Material.Scheme.top
