module State exposing (..)

import Material
import Navigation as Nav
import Types exposing (..)
import Task exposing (perform)
import RemoteData exposing (RemoteData(..))

import Server.API.Queries.Authentication as Server exposing (loginUser)

import Client.Login.Login as Login exposing (initModel)
import Client.Pages.Home.Home as HomePage



mdlModel : Material.Model
mdlModel =
    Material.model

init : Flags -> Nav.Location -> ( Model, Cmd Msg )
init flags location  =
    let
       z = Debug.log "Flags: " flags
    in
        (initModel flags, reactFirstUrl location)

initModel: Flags -> Model
initModel flags =
    { appConfig = {apiBaseUrl=flags.apiBaseUrl}
    , history = []
    , currentViewModel = Login (Login.initModel mdlModel)
    }

reactFirstUrl: Nav.Location -> Cmd Msg
reactFirstUrl location =
  let
    intendedView =
      getPage location.hash

    isAuthenticated =
      isAuthenticatedToView intendedView
  in
    if isAuthenticated then
      performSwitchView intendedView Nothing
    else
      Cmd.none --Assumes that Login is the default view loaded in init


--TODO: Should check for jwt and communicate with server to authenticate
isAuthenticatedToView: ViewState -> Bool
isAuthenticatedToView view =
  True

performSwitchView: ViewState -> Maybe String -> Cmd Msg
performSwitchView viewState maybeUrlChange =
  Task.perform
    (always (ChangeView viewState maybeUrlChange))
    (Task.succeed ())

getPage : String -> ViewState
getPage hash =
    case hash of
        "#home" ->
            HomePageView
        "#login" ->
            LoginView
        _ ->
          LoginView

updateModelView: Model -> ViewModel -> Maybe (Cmd Msg) -> (Model, Cmd Msg)
updateModelView model newViewModel maybeCmd =
  let
    cmd =
      Maybe.withDefault Cmd.none maybeCmd
  in
     ({model | currentViewModel = newViewModel}, cmd)


getInitViewModel: ViewState -> ViewModel
getInitViewModel viewState =
  case viewState of
    LoginView ->
      Login (Login.initModel mdlModel)
    HomePageView ->
      HomePage HomePage.model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
          let
            viewState = getPage location.hash
            h = Debug.log "HASH!: " location.hash
          in
            updateModelView model (getInitViewModel viewState) Nothing
        Mdl message_ ->
            (model, Cmd.none)
        ChangeView viewState maybeUrlChange ->
          case maybeUrlChange of
            Just url ->
              (model, Nav.newUrl url)
            Nothing ->
              updateModelView model (getInitViewModel viewState) Nothing
        ChildPageMsg childMsg ->
          case childMsg of
            HomePageMsg msg ->
              let
                updatedHomeModel =
                  HomePage.update msg HomePage.model
              in
                updateModelView model (HomePage updatedHomeModel) Nothing
        LoginMsg logMsg curLogModel ->
          let
              (newLoginModel, loginMsg) =
                Login.update logMsg curLogModel

              serverContext = {apiBaseUrl=model.appConfig.apiBaseUrl}
          in
            case logMsg of
              Login.Submit email password->
                (model, Server.loginUser serverContext email password |> Cmd.map ReceiveAuthentication)
              _ ->
                ({model | currentViewModel = Login newLoginModel}, Cmd.none)

        ReceiveAuthentication response ->
          case Debug.log "response!: " response of
            Success token ->
              (model, performSwitchView HomePageView (Just "#home"))
            _ ->
              (model, Cmd.none)


subscriptions: Model -> Sub Msg
subscriptions model = Sub.none
