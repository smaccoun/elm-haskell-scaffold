module Server.API.Queries.Authentication exposing (..)

import Http exposing (..)
import Json.Encode as Encode exposing (encode, object, string)
import Json.Decode as Decode exposing (list, string, decodeString, bool)
import RemoteData exposing (sendRequest)

import Server.Config.APIServer as Server exposing (Context, getServerAPIPaths, ServerAPIPaths(..))


type alias Email =
    String


type alias Password =
    String



loginBody : Email -> Password -> Http.Body
loginBody email password =
    jsonBody
        (object
            [ ( "email", Encode.string email )
            , ( "password", Encode.string password )
            ]
        )



loginUser : Server.Context -> Email -> Password -> Cmd (RemoteData.WebData String)
loginUser context email password =
    Http.post
        (getServerAPIPaths context Login )
        (loginBody email password)
        (Decode.bool |> Decode.map toString)
        |> RemoteData.sendRequest
