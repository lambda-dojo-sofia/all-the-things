module Main where

main :: IO ()
main = do dict <- fmap (\s -> words' (length from) s) $ readFile "../../resources/datafiles/dictionary.txt"
          print (oneOffs "leg" dict)

from = "leg"
to = "cog"

words' :: Int -> String -> [String]
words' l s = filter (\x -> length x == l) (words s)

isOneOff :: String -> String -> Bool
isOneOff a b = 1 == (length $ filter (\x -> x == False) (map (\(a,b) -> a == b) $ zip a b))

oneOffs ::  String -> [String] -> [String]
oneOffs from dict = filter (\fromDict -> isOneOff from fromDict) dict



-- generate

