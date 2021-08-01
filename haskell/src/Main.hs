{-# LANGUAGE OverloadedStrings #-}

module Main where

import API (apiRouter)
import Data.Maybe (fromJust)
import Helpers (app404, router)
import Network.HTTP.Types as H (status200)
import Network.Wai as Wai (Application, responseFile)
import Network.Wai.Application.Static as Static
  ( StaticSettings (ss404Handler, ssIndices),
    defaultWebAppSettings,
    staticApp,
  )
import Network.Wai.Handler.Warp as Warp (run)
import Network.Wai.Middleware.Gzip (def, gzip)
import Network.Wai.Middleware.RequestLogger (logStdout)
import WaiAppStatic.Types (toPieces)

mainRouter :: Application
mainRouter = 
  router
    [ ("api", API.apiRouter)
    , ("static", static)
    ]
    webApp

webApp :: Application
webApp _ respond = do
  respond $
    Wai.responseFile
      H.status200
      [("Content-Type", "text/html")]
      "./static/webapp.html"
      Nothing

static :: Application
static =
  Static.staticApp $
    (Static.defaultWebAppSettings "./static/") {Static.ssIndices = fromJust $ toPieces ["index.html"], Static.ss404Handler = Just app404}

main :: IO ()
main = do
  putStrLn "http://localhost:8080/"
  Warp.run 8080 $ logStdout $ gzip def mainRouter
