module Server.Config.APIServer exposing (..)


type ServerAPIPaths = Base | Login

baseUrl = "http://localhost:8080"

serverAPIPaths: ServerAPIPaths -> String
serverAPIPaths paths =
    case paths of
        Base ->
           baseUrl
        Login ->
           baseUrl ++ "/users/login"







