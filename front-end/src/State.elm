module State exposing (..)

import Material
import Navigation as Nav
import Types exposing (..)
import Time exposing (Time, hour)
import Date exposing (Date, fromTime)
import Date.Extra.Compare as CompareDate exposing (Compare2(..))
import Task exposing (perform)
import RemoteData exposing (RemoteData(..))
import Tuple exposing (first)

import Client.Login.Login as Login exposing (initModel)
import Server.API.Queries.Authentication as Server exposing (loginUser)


mdlModel : Material.Model
mdlModel =
    Material.model


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    (initModel, Cmd.none)

initModel: Model
initModel =
    { history = []
    , currentViewState = Login (Login.initModel mdlModel)
    }

switchView: ViewState -> Cmd Msg
switchView viewState =
  Task.perform
    (always (ChangeView viewState))
    (Task.succeed ())

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
          (model, Cmd.none)
        Mdl message_ ->
            (model, Cmd.none)
        ChangeView viewState ->
          case viewState of
            LoginView ->
              ({model | currentViewState = Login (Login.initModel mdlModel)}, Cmd.none)
        LoginMsg logMsg curLogModel ->
          let
              (newLoginModel, loginMsg) =
                Login.update logMsg curLogModel
          in
            case logMsg of
              Login.Submit email password->
                (model, loginUser email password |> Cmd.map ReceiveAuthentication)
              _ ->
                ({model | currentViewState = Login newLoginModel}, Cmd.none)

        ReceiveAuthentication response ->
          case Debug.log "response!: " response of
            Success token ->
              (model, Cmd.none)
            _ ->
              (model, Cmd.none)

subscriptions: Model -> Sub Msg
subscriptions model = Sub.none
