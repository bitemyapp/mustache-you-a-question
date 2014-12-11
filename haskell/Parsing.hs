{-# LANGUAGE OverloadedStrings #-}

module Parsing where

import Control.Applicative
import Data.Attoparsec.Text
import Data.Char (isAlpha)
import Data.Maybe (fromMaybe)
import Data.Monoid
import Data.Text (Text)
import qualified Data.Text.IO as TIO
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M

newtype Var = Var Text deriving Show

data Node = VarNode Var | TextNode Text deriving Show
type Context = (Map Text Text)

parseDoubleCurly :: Parser a -> Parser a
parseDoubleCurly p = string "{{" *> p <* string "}}"

-- parseVar :: Parser Var
-- parseVar = do
--   string "{{"
--   name <- takeWhile1 isAlpha
--   string "}}"
--   return $ Var name

parseVar :: Parser Var
parseVar = parseDoubleCurly $ (Var <$> takeWhile1 isAlpha)

parseNode :: Parser Node
parseNode = TextNode <$> takeWhile1 (/= '{')

parseStream :: Parser [Node]
parseStream = many $ (parseNode <|> (VarNode <$> parseVar))

renderNode :: Context -> Node -> Text
renderNode ctx (VarNode (Var name)) = fromMaybe "" (M.lookup name ctx)
renderNode ctx (TextNode txt) = txt

render :: Context -> [Node] -> Text
render context nodes = foldr
       (\node extant ->
         mappend (renderNode context node) extant)
         "" nodes

main = do
  let context  = M.fromList [("blah", "1")]
  let parser   = parseOnly parseStream
  let template = "{{blah}} woot"
  let maybeRendered = (render context <$> (parser template))
  putStrLn (show maybeRendered)
