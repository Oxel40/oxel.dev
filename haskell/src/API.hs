{-# LANGUAGE OverloadedStrings #-}

module API where

import qualified Data.ByteString.Lazy.Char8 as L8
import Data.Time (getCurrentTime)
import Helpers (app404, router)
import Network.HTTP.Types as H (status200)
import Network.Wai as Wai
  ( Application,
    Request (pathInfo),
    responseLBS,
  )

apiRouter :: Application
apiRouter =
  router
    [ ("list", listApp),
      ("time", timeApp)
    ]
    app404

listApp :: Application
listApp req respond = do
  respond $
    Wai.responseLBS
      H.status200
      [("Content-Type", "text/plain")]
      (L8.pack $ show $ Wai.pathInfo req)

timeApp :: Application
timeApp _ respond = do
  time <- getCurrentTime
  respond $
    Wai.responseLBS
      H.status200
      [("Content-Type", "text/plain")]
      (L8.pack $ show time)
