module Server.Config.APIServer exposing (..)


type ServerAPIPaths = Base | Login

type alias Context =
  {apiBaseUrl: String

  }


getServerAPIPaths: Context -> ServerAPIPaths -> String
getServerAPIPaths context paths =
    case paths of
        Base ->
           context.apiBaseUrl
        Login ->
           context.apiBaseUrl ++ "/users/login"







