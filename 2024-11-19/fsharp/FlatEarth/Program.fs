open FSharp.Data
open System
type CsvData = CsvProvider<Sample="city,city_ascii,lat,lng,country,iso2,iso3,admin_name,capital,population,id\nTokyo,Tokyo,35.6897,139.6922,Japan,JP,JPN,Tōkyō,primary,37732000,1392685764">

let csv = CsvData.Load "D:\FlatEarth\FlatEarth\world-cities.csv"

let city_by_name (name: string) =
    csv.Rows |> Seq.find (fun row -> row.City.ToLower () = name.ToLower ())

let rec read_city () = 
    printfn "Enter city"
    let name = Console.ReadLine()
    try
        let city = city_by_name name
        printfn "You selected %s, %s!" city.City city.Country
        city
    with
        _ ->
            printfn "Nah, bro. Try again..."
            read_city ()

let a = read_city ()
let b = read_city ()

let radians (degrees: decimal) = float degrees * (Math.PI / 180.)
let dist (a:CsvData.Row) (b:CsvData.Row) =
    let r = 6371e3
    let dlat = radians b.Lat - radians a.Lat
    let dlng = radians b.Lng - radians a.Lng
    let A = sin(dlat/2.)**2 + cos(radians a.Lat) * cos(radians b.Lat) * sin(dlng/2.)**2
    let c = 2. * atan2 (sqrt A) (sqrt (1.-A))
    r * c

printfn "Distance between %s, %s and %s, %s is %.3f km" a.City a.Country b.City b.Country ((dist a b) / 1000.)

type Json = JsonProvider<"google_distance_matrix.json">

let response = Http.RequestString("https://maps.googleapis.com/maps/api/distancematrix/json",
    query=["destinations", sprintf "%.4f, %.4f" a.Lat a.Lng;
    "origins", sprintf "%.4f, %.4f" b.Lat b.Lng;
    "units", "metric";
    "key", "AIzaSyDmXSiWwfYoznJMxalXZPdhneCb4whBghI"])

let data = Json.Parse(response)

if data.Status = "OK" && data.Rows.[0].Elements.[0].Status = "OK" then
    printfn "Driving distance: %s" data.Rows.[0].Elements.[0].Distance.Text
else
    printfn "You can't drive there, mate!"