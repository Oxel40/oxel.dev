{-# LANGUAGE OverloadedStrings #-}

module Helpers where

import Data.Map ((!))
import qualified Data.Map as Map
import Data.Text (Text)
import Network.HTTP.Types as H (status404)
import Network.Wai as Wai
  ( Application,
    Request (pathInfo),
    responseFile,
  )

router :: [(Text, Application)] -> Application -> Application
router routeList defaultApp req respond
  | Prelude.null path = defaultApp req respond
  | Map.member headPath rMap = (rMap ! headPath) (req {Wai.pathInfo = subPath}) respond
  | otherwise = defaultApp req respond
  where
    path = Wai.pathInfo req
    subPath = tail path
    headPath = head path
    rMap = Map.fromList routeList

app404 :: Application
app404 _ respond = do
  respond $
    Wai.responseFile
      H.status404
      [("Content-Type", "text/html")]
      "./static/404.html"
      Nothing
      
