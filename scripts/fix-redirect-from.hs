#!/usr/bin/env stack
-- stack --nix --resolver lts-12.24 --install-ghc runghc --package frontmatter --package yaml --package text --package bytestring --package attoparsec
{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad
import           Data.Attoparsec.Text
import qualified Data.ByteString  as ByteString
import           Data.Char
import qualified Data.Frontmatter as Frontmatter
import qualified Data.HashMap.Strict as H
import           Data.Maybe
import           Data.Text        (Text)
import qualified Data.Text        as Text
import qualified Data.Yaml.Pretty as Y
import           Data.Yaml        (ToJSON(..), FromJSON(..), Value(..), Array, Object, withObject, (.:?), (.!=))
import           System.Directory
import           System.FilePath

data Post = Post
  { postYear :: Text
  , postMonth :: Text
  , postDay :: Text
  , postSlug :: Text
  } deriving (Show)

data PostMeta = PostMeta
  { postMetaCategories :: [Text]
  , postMetaRedirectFrom :: [Text]
  , postMetaOther :: Object
  } deriving (Show)

instance FromJSON PostMeta where
  parseJSON = withObject "PostMeta" $ \v -> PostMeta
    <$> v .:? "categories" .!= []
    <*> v .:? "redirect_from" .!= []
    <*> pure v

instance ToJSON PostMeta where
  toJSON (PostMeta categories redirectFrom other) = toJSON
    . H.insert "categories" (toJSON categories)
    . H.insert "redirect_from" (toJSON redirectFrom)
    $ other

parsePost :: FilePath -> Maybe Post
parsePost = either (const Nothing) Just . parseOnly postParser . Text.pack

postParser :: Parser Post
postParser = do
  year <- takeWhile1 isDigit <* char '-'
  month <- takeWhile1 isDigit <* char '-'
  day <- takeWhile1 isDigit <* char '-'
  slug <- takeTill (== '.')
  return Post
    { postYear  = year
    , postMonth = month
    , postDay   = day
    , postSlug  = slug
    }

updateRedir :: Post -> PostMeta -> PostMeta
updateRedir (Post y m d s) pm = pm
  { postMetaRedirectFrom =
      [ Text.intercalate "/" $
          [""] ++ (map Text.toLower $ postMetaCategories pm) ++ ["archives", y, m, d, s]
      ]
  }

updateFile :: (FilePath, Post) -> IO ()
updateFile (fp, p) = do
  input <- ByteString.readFile fp
  case Frontmatter.parseYamlFrontmatter input of
    Done ri fm | null (postMetaRedirectFrom fm) -> do
      putStrLn fp
      ByteString.writeFile fp . ByteString.concat $
        [ "---\n"
        , Y.encodePretty Y.defConfig $ updateRedir p fm
        , "---\n"
        , ri
        ]
    _ -> return ()

getPosts :: FilePath -> IO [(FilePath, Post)]
getPosts fp = mapMaybe go <$> getDirectoryContents fp
  where go f = (,) (fp </> f) <$> parsePost f

main :: IO ()
main = getPosts "_posts" >>= mapM_ updateFile
