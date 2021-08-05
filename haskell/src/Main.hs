{-# LANGUAGE OverloadedStrings #-}

module Main where

import API (apiRouter)
import Data.Maybe (fromJust)
import Network.HTTP.Types as H (status200)
import Network.Wai as Wai (Application, pathInfo, responseBuilder, responseFile)
import Network.Wai.Application.Static as Static
  ( StaticSettings (ss404Handler, ssIndices),
    defaultWebAppSettings,
    staticApp,
  )
import Network.Wai.Handler.Warp as Warp (run)
import Network.Wai.Middleware.Gzip (def, gzip)
import Network.Wai.Middleware.RequestLogger (logStdout)
import Util (res404, resIndex)
import WaiAppStatic.Types (toPieces)

mainRouter :: Application
mainRouter req respond = case pathInfo req of
  ("api" : rest) -> API.apiRouter (req {Wai.pathInfo = rest}) respond
  ("static" : rest) -> static (req {Wai.pathInfo = rest}) respond
  _ -> resIndex req respond

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
    (Static.defaultWebAppSettings "./static/") {Static.ssIndices = fromJust $ toPieces ["index.html"], Static.ss404Handler = Just res404}

main :: IO ()
main = do
  putStrLn "http://localhost:8080/"
  Warp.run 8080 $ logStdout $ gzip def mainRouter
