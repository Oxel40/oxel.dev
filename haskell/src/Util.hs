{-# LANGUAGE OverloadedStrings #-}

module Util where

import Network.HTTP.Types as H (status200, status404)
import Network.Wai as Wai (Application, responseBuilder)
--import Text.Blaze.Html (Html)
import Text.Blaze.Html.Renderer.Utf8 as R (renderHtmlBuilder)
import Text.Blaze.Html5 as H5
import Text.Blaze.Html5.Attributes as H5A

res404 :: Application
res404 _ respond = do
  respond $
    Wai.responseBuilder
      H.status404
      [("Content-Type", "text/html")]
      $ R.renderHtmlBuilder $
        H5.html $
          do
            H5.head $ do
              H5.meta ! H5A.charset "utf-8"
              H5.title "My HTML page"
            H5.body $ do
              H5.h1 "Welcome to our site!"

resIndex :: Application
resIndex _ respond = do
  respond $
    Wai.responseBuilder
      H.status200
      [("Content-Type", "text/html")]
      $ R.renderHtmlBuilder htmlIndex

htmlIndex :: H5.Html
htmlIndex = H5.docTypeHtml $ do
  H5.head $ do
    H5.meta ! H5A.charset "utf-8"
    H5.title "Blaze WebApp"
    H5.script ! H5A.type_ "text/javascript" ! H5A.src "/static/webapp.js" $ ""
    H5.link ! H5A.rel "icon" ! H5A.type_ "image/x-icon" ! H5A.href "/static/favicon.ico"
  H5.body $ do
    H5.script ! H5A.type_ "text/javascript" $ "var app = Elm.WebApp.init();"