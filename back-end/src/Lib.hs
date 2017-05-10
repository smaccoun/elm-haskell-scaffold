{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}

module Lib
    ( startApp
    ) where

import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Network.Wai.Middleware.RequestLogger as MidRL
import qualified Network.Wai.Middleware.AddHeaders as Mah
import Debug.Trace (trace)
import Network.HTTP.Types.Method
import Network.Wai.Middleware.Cors
import Servant ((:<|>)( .. ), (:>), (:~>))
import qualified Servant as S
import Control.Monad.Trans.Reader (runReaderT)
import Control.Monad.Trans.Except (ExceptT)
import Control.Monad.IO.Class (liftIO)
import qualified Database.PostgreSQL.Simple as PGS
import qualified Data.Pool as Pool
import qualified System.Log.FastLogger as FL
import Data.Default.Class (def, Default)
import Data.Maybe (listToMaybe)

import App (Config ( .. )
           , AppM
           , Environment ( .. )
           , LogTo ( .. )
           , lookupEnvDefault
           )
import Api.User

type API = "users" :> UserAPI

data ConnectionInfo = ConnectionInfo
                      { connUser :: String
                      , connPassword :: String
                      , connDatabase :: String
                      }

instance Default ConnectionInfo where
  def = ConnectionInfo
        { connUser = "postgres"
        , connPassword = "password"
        , connDatabase = "inner_space"
        }

getConnInfo :: IO ConnectionInfo
getConnInfo =
  ConnectionInfo <$>
    lookupEnvDefault "SERVANT_PG_USER" (connUser def) <*>
    lookupEnvDefault "SERVANT_PG_PWD" (connPassword def) <*>
    lookupEnvDefault "SERVANT_PG_DB" (connDatabase def)

connInfoToPG :: ConnectionInfo -> PGS.ConnectInfo
connInfoToPG connInfo = PGS.defaultConnectInfo
                        { PGS.connectUser = connUser connInfo
                        , PGS.connectPassword = connPassword connInfo
                        , PGS.connectDatabase = connDatabase connInfo
                        }

openConnection :: IO PGS.Connection
openConnection = do
  connInfo <- getConnInfo
  PGS.connect (connInfoToPG connInfo)

makeLogger :: LogTo -> IO FL.LoggerSet
makeLogger logTo = case logTo of
        STDOut -> FL.newStdoutLoggerSet FL.defaultBufSize
        STDErr -> FL.newStderrLoggerSet FL.defaultBufSize
        File filename -> FL.newFileLoggerSet FL.defaultBufSize filename

makeMiddleware :: FL.LoggerSet -> Environment -> IO Wai.Middleware
makeMiddleware logger env = case env of
      Test -> return id
      Production -> MidRL.mkRequestLogger $ def { MidRL.destination = MidRL.Logger logger
                                                , MidRL.outputFormat = MidRL.Apache MidRL.FromSocket
                                                }
      Development ->
          combineMiddleWare corsified
        $ MidRL.mkRequestLogger
        $ def { MidRL.destination = MidRL.Logger logger }

combineMiddleWare :: Wai.Middleware -> IO Wai.Middleware -> IO Wai.Middleware
combineMiddleWare first second =
   fmap (. first) second

startApp :: [String] -> IO ()
startApp args = do
  port <- lookupEnvDefault "SERVANT_PORT" 8080
  env <- lookupEnvDefault "SERVANT_ENV" Development
  logTo <- case listToMaybe args of
    Just filename -> return $ File filename
    Nothing -> lookupEnvDefault "SERVANT_LOG" STDOut
  pool <- Pool.createPool openConnection PGS.close 1 10 5
  logger <- makeLogger logTo
  midware <- makeMiddleware logger env
  FL.pushLogStrLn logger $ FL.toLogStr $
    "Listening on port " ++ show port ++ " at level " ++ show env ++ " and logging to "  ++ show logTo ++ " with args " ++ unwords args
  Warp.run port $ midware $ app (Config pool logger)

readerTToExcept :: Config -> AppM :~> ExceptT S.ServantErr IO
readerTToExcept pool = S.Nat (\r -> runReaderT r pool)

-- | @x-csrf-token@ allowance.
-- The following header will be set: @Access-Control-Allow-Headers: x-csrf-token@.
allowCsrf :: Wai.Middleware
allowCsrf = Mah.addHeaders [("Access-Control-Allow-Headers", "x-csrf-token,authorization")]

-- | CORS middleware configured with 'appCorsResourcePolicy'.
corsified :: Wai.Middleware
corsified = cors (const $ Just appCorsResourcePolicy)

-- | Cors resource policy to be used with 'corsified' middleware.
--
-- This policy will set the following:
--
-- * RequestHeaders: @Content-Type@
-- * MethodsAllowed: @OPTIONS, GET, PUT, POST@
appCorsResourcePolicy :: CorsResourcePolicy
appCorsResourcePolicy = CorsResourcePolicy {
    corsOrigins        = Nothing
  , corsMethods        = ["OPTIONS", "GET", "PUT", "POST"]
  , corsRequestHeaders = ["Authorization", "Content-Type"]
  , corsExposedHeaders = Nothing
  , corsMaxAge         = Nothing
  , corsVaryOrigin     = False
  , corsRequireOrigin  = False
  , corsIgnoreFailures = False
}


app :: Config -> Wai.Application
app pool = S.serve api
          $ S.enter (readerTToExcept pool) server

api :: S.Proxy API
api = S.Proxy

server :: S.ServerT API AppM
server = userServer
