module View exposing (view)

import Html exposing (Html, a, button, div, h1, h4, img, li, p, text, ul)
import Html.Attributes exposing (href, src, style)
import Html.Events exposing (onClick)

import Types exposing (..)
import Client.Login.Login as Login exposing (view)


view : Model -> Html Msg
view model =
  case model.currentViewState of
    Login loginModel ->
      Html.map (\m -> LoginMsg m loginModel) (Login.view loginModel)
