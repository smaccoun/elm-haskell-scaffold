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
    , currentViewModel = Login (Login.initModel mdlModel)
    }

performSwitchView: ViewState -> Cmd Msg
performSwitchView viewState =
  Task.perform
    (always (ChangeView viewState))
    (Task.succeed ())

updateModelView: ViewState -> Model -> Maybe (Cmd Msg) -> (Model, Cmd Msg)
updateModelView newView model maybeCmd =
  let
    cmd =
      Maybe.withDefault Cmd.none maybeCmd
  in
      case newView of
          LoginView ->
            ({model | currentViewModel = Login (Login.initModel mdlModel)}, cmd)
          HomePageView ->
            ({model | currentViewModel = HomePage}, cmd)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
          (model, Cmd.none)
        Mdl message_ ->
            (model, Cmd.none)
        ChangeView viewState ->
          updateModelView viewState model Nothing
        LoginMsg logMsg curLogModel ->
          let
              (newLoginModel, loginMsg) =
                Login.update logMsg curLogModel
          in
            case logMsg of
              Login.Submit email password->
                (model, loginUser email password |> Cmd.map ReceiveAuthentication)
              _ ->
                ({model | currentViewModel = Login newLoginModel}, Cmd.none)

        ReceiveAuthentication response ->
          case Debug.log "response!: " response of
            Success token ->
              (model, performSwitchView HomePageView)
            _ ->
              (model, Cmd.none)

subscriptions: Model -> Sub Msg
subscriptions model = Sub.none
