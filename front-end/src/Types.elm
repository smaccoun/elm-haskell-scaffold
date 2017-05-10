module Types exposing (..)

import Material
import Navigation as Nav
import RemoteData exposing (WebData)

import Client.Login.Login as Login exposing (Model)


type alias Model =
    { history : List Nav.Location
    , currentViewModel : ViewModel
    }


type ViewModel
    = Login Login.Model
    | HomePage


type ViewState = LoginView | HomePageView

type Msg
    = UrlChange Nav.Location
    | Mdl (Material.Msg Msg)
    | LoginMsg Login.Msg Login.Model
    | ChangeView ViewState
    | ReceiveAuthentication (RemoteData.WebData String)


type alias Url =
    String
