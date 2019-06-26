module Main where

main :: IO ()
main = do
  s <- readFile "/usr/share/dict/words"

words' :: Int -> IO [String]
words' l = filter (\x -> length x == l) $ fmap words $ readFile "/usr/share/dict/words"

isWord :: String -> [String] -> Bool
isWord w ws = elem w ws

-- generate

