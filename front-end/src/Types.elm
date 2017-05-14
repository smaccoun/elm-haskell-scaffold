module Types exposing (..)

import Material
import Navigation as Nav
import RemoteData exposing (WebData)

import Client.Login.Login as Login exposing (Model)
import Client.Pages.Home.Home as HomePage exposing (Msg(..))


type alias Flags =
  {nodeEnv: String
  ,apiBaseUrl: String
  }

type alias AppConfig =
  {apiBaseUrl: String}

type alias Model =
    { appConfig: AppConfig
    , history : List Nav.Location
    , currentViewModel : ViewModel
    }


type ViewModel
    = Login Login.Model
    | HomePage HomePage.Model


type ViewState = LoginView | HomePageView

type ChildPageMsgs = HomePageMsg HomePage.Msg

type Msg
    = UrlChange Nav.Location
    | Mdl (Material.Msg Msg)
    | LoginMsg Login.Msg Login.Model
    | ChildPageMsg ChildPageMsgs
    | ChangeView ViewState (Maybe String)
    | ReceiveAuthentication (RemoteData.WebData String)


type alias Url =
    String
