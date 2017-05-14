port module Main exposing (main)

import Navigation as Nav
import Types exposing (..)
import State exposing (..)
import View exposing (..)


main : Program Flags Model Msg
main =
    Nav.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

