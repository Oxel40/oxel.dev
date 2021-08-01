{-# LANGUAGE TemplateHaskell #-}

module Templates where

import Language.Haskell.TH

router :: [(String, Name)] -> Name -> Q Exp
router entries def = do
  x <- newName "x"
  return $ LamE [VarP x] (CaseE (VarE x) (map (\(a, b) -> Match (LitP $ StringL a) (NormalB $ VarE b) []) entries ++ [Match WildP (NormalB $ VarE def) []]))
