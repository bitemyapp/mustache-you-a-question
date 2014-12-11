{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Criterion.Main
import Data.Attoparsec.Text (parseOnly)
import qualified Data.Map.Lazy as M
import qualified Parsing as P
import qualified Data.Text as T

templateString :: T.Text
templateString = "Hello, {{name}}, so nice to see you."

bigString :: T.Text
bigString = T.concat $ take 10000 $ repeat templateString

context = M.fromList [("name", "Guy")]

parser = parseOnly P.parseStream
parseAndRender context template = P.render context <$> parser template

preParsedSmall = parser templateString
preParsedBig = parser bigString

main :: IO ()
main = do
  defaultMain [ bench "parse and render small" $ whnf (parseAndRender context) templateString
              , bench "render small" $ whnf (fmap (P.render context)) preParsedSmall
              , bench "parse and render big" $ whnf (parseAndRender context) bigString
              , bench "render big" $ whnf (fmap (P.render context)) preParsedBig
              , bench "nf parse and render small" $ whnf (parseAndRender context) templateString
              , bench "nf render small" $ whnf (fmap (P.render context)) preParsedSmall
              , bench "nf parse and render big" $ whnf (parseAndRender context) bigString
              , bench "nf render big" $ whnf (fmap (P.render context)) preParsedBig
              ]
