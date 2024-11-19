import std/strutils
import tables
import os
import math

let entireFile = readFile("../resources/datafiles/world-cities.csv")

type Coordinates = tuple[lat: float64, lng: float64]
var cities = initTable[string, Coordinates]()

let lines = entireFile.replace("\"", "").split("\n")
for l in lines[1..lines.len-2]:
  let parsedLine = l.split(",")
  let
    cityName = parsedLine[1].toLowerAscii
    lat = parseFloat(parsedLine[2])
    lng = parseFloat(parsedLine[3])
  let currentCoordinates: Coordinates =(lat:lat, lng:lng)
  cities[cityName] = currentCoordinates

let 
  cityFromName = paramStr(1).toLowerAscii
  cityToName = paramStr(2).toLowerAscii
  cityFrom = cities[cityFromName]
  cityTo = cities[cityToName]

proc toRadians(a: float64): float64 =
  return a * PI / 180
  
proc calculateLenght(a: Coordinates,b: Coordinates): float64 =
  let 
    diffInLng = toRadians(b.lng - a.lng)
    diffInLat = toRadians(b.lat - a.lat)
    a = (1 - cos(diffInLat)) / 2 + cos(toRadians(a.lat))*cos(toRadians(b.lat))*((1 - cos(diffInLng)) / 2)
    c = 2 * arctan2(sqrt(a), sqrt(1-a))
    d = 6371 * c

  return d

echo calculateLenght(cityFrom, cityTo)