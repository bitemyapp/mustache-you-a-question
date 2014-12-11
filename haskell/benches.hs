{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Criterion.Main
import Data.Attoparsec.Text (parseOnly)
import qualified Data.Map.Lazy as M
import qualified Parsing as P
import qualified Data.Text as T
import qualified Data.Vector as V

templateString :: T.Text
templateString = "Hello, {{name}}, so nice to see you."

bigString :: T.Text
bigString = T.concat $ take 1000 $ repeat templateString

context :: M.Map T.Text T.Text
context = M.fromList [("name", "Guy")]

parser :: T.Text -> Either String [P.Node]
parser = parseOnly P.parseStream

parserV :: T.Text -> Either String (V.Vector P.Node)
parserV = parseOnly P.parseVector

{-# NOINLINE parseAndRender #-}
parseAndRender :: P.Context -> T.Text -> Either String T.Text
parseAndRender context template = P.render context <$> parser template

{-# NOINLINE parseAndRenderV #-}
parseAndRenderV :: P.Context -> T.Text -> Either String T.Text
parseAndRenderV context template = P.renderV context <$> parserV template

{-# NOINLINE preParsedSmall #-}
preParsedSmall :: Either String [P.Node]
preParsedSmall = parser templateString

{-# NOINLINE preParsedBig #-}
preParsedBig :: Either String [P.Node]
preParsedBig = parser bigString

{-# NOINLINE preParsedSmallV #-}
preParsedSmallV :: Either String (V.Vector P.Node)
preParsedSmallV = parserV templateString

{-# NOINLINE preParsedBigV #-}
preParsedBigV :: Either String (V.Vector P.Node)
preParsedBigV = parserV bigString

{-# NOINLINE parLength #-}
parLength :: P.Context -> T.Text -> (Either String Int, Either String T.Text)
parLength context template = (fmap T.length result, result)
  where result = parseAndRender context template

main :: IO ()
main = do
  defaultMain [ bench "parse and render small" $ whnf (parseAndRender context) templateString
              , bench "render small" $ whnf (fmap (P.render context)) preParsedSmall
              , bench "parse and render big" $ whnf (parseAndRender context) bigString
              , bench "render big" $ whnf (fmap (P.render context)) preParsedBig

                -- with vector
              , bench "vector parse and render small" $ whnf (parseAndRenderV context) templateString
              , bench "vector render small" $ whnf (fmap (P.renderV context)) preParsedSmallV
              , bench "vector parse and render big" $ whnf (parseAndRenderV context) bigString
              , bench "vector render big" $ whnf (fmap (P.renderV context)) preParsedBigV

                -- with nf vector
              -- , bench "nf vector parse and render small" $ nf (parseAndRenderV context) templateString
              -- , bench "nf vector render small" $ nf (fmap (P.renderV context)) preParsedSmallV
              -- , bench "nf vector parse and render big" $ nf (parseAndRenderV context) bigString
              -- , bench "nf vector render big" $ nf (fmap (P.renderV context)) preParsedBigV

                -- with length
              , bench "parLength small" $ whnf (parLength context) templateString
              , bench "render small" $ whnf (fmap (P.render context)) preParsedSmall
              , bench "parLength big" $ whnf (parLength context) bigString
              , bench "render big" $ whnf (fmap (P.render context)) preParsedBig

                -- nf
              -- , bench "nf parse and render small" $ nf (parseAndRender context) templateString
              -- , bench "nf render small" $ nf (fmap (P.render context)) preParsedSmall
              -- , bench "nf parse and render big" $ nf (parseAndRender context) bigString
              -- , bench "nf render big" $ nf (fmap (P.render context)) preParsedBig

                -- nf with length
              -- , bench "nf parLength small" $ nf (parLength context) templateString
              -- , bench "nf render small" $ nf (fmap (P.render context)) preParsedSmall
              -- , bench "nf parLength big" $ nf (parLength context) bigString
              -- , bench "nf render big" $ nf (fmap (P.render context)) preParsedBig
              ]
