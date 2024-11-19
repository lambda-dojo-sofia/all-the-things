import Data.List

main = do
  s <- readFile "./all-the-things/resources/datafiles/world-cities.csv"
  print $ calculateDistance $ (translateInput (splitLines s))

-- haversine
haversine :: (RealFloat a) => (a, a) -> (a, a) -> a
haversine (lat1, lon1) (lat2, lon2) = d
  where
    r = 6371
    rlat1 = lat1 * (pi / 180)
    rlat2 = lat2 * (pi / 180)
    rlon1 = lon1 * (pi / 180)
    rlon2 = lon2 * (pi / 180)
    dlat = rlat2 - rlat1
    dlon = rlon2 - rlon1
    a = (sin (dlat / 2)) * (sin (dlat / 2)) + (cos rlat1) * (cos rlat2) * (sin (dlon / 2)) * (sin (dlon / 2))
    c = 2 * atan2 (sqrt a) (sqrt (1 - a))
    d = r * c
    -- result = 2 * r * asin (sqrt h)
    -- r = 6371
    -- dlat = lat2 - lat1
    -- dlon = lon2 - lon1
    -- a = sin (dlat / 2) ^ 2 + cos lat1 * cos lat2 * sin (dlon / 2) ^ 2
    -- h = a
    -- d = r * 

calculateDistance :: [CityModel] -> Float
calculateDistance xs = haversine ((lat start) , (lng start)) ((lat end) , (lng end))
  where 
    [start, end] = take 2 $ drop 1 $ xs

splitLines :: String -> [String]
splitLines str = lines str

convertToCityModel :: String -> CityModel
convertToCityModel x = CityModel {city = xs !! 0, lat = read (xs !! 2), lng = read (xs !! 3)} 
  where xs = (split ',' (head (splitLines x)))

translateInput :: [String] -> [CityModel]
translateInput xs = map convertToCityModel xs

split :: Eq a => a -> [a] -> [[a]]
split d [] = []
split d s = x : split d (drop 1 y) where (x,y) = span (/= d) s

-- readMyFile :: IO String
-- readMyFile = readFile "./all-the-things/resources/datafiles/world-cities.csv"

-- main = putStrLn $ fmap readMyFile

-- -- data type to model a FinancialInstrument
data CityModel = CityModel
  { city :: String,
    lat :: Float,
    lng :: Float
  }
  deriving (Show, Eq)
