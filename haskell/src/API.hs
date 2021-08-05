{-# LANGUAGE OverloadedStrings #-}

module API where

import qualified Data.ByteString.Lazy.Char8 as L8
import Data.Time (getCurrentTime)
import Network.HTTP.Types as H (status200)
import Network.Wai as Wai
  ( Application,
    Request (pathInfo),
    responseLBS,
  )
import Util (res404)

apiRouter :: Application
apiRouter req respond = case pathInfo req of
  ("list" : rest) -> listApp (req {Wai.pathInfo = rest}) respond
  ["time"] -> timeApp req respond
  _ -> res404 req respond

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
