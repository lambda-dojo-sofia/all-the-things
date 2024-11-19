use std::{collections::HashMap, error::Error, fs::File, io::Read};

use serde_json::Value;

#[derive(Debug)]
struct Point {
    latitude: f64,
    longitude: f64,
}

type MyError<T> = Result<T, Box<dyn Error>>;

const EARTH_RADIUS_KM: f64 = 6371.;

fn distance(p1: &Point, p2: &Point) -> f64 {
    /*
    a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)`
    c = 2 ⋅ atan2( √a, √(1−a) )
    d = R ⋅ c

    # where: 	φ is latitude, λ is longitude, R is earth’s radius(if it wasn't flat, it would be somewhere around 6371 km).
    # note that angles need to be in radians to pass to trig functions!
    */

    let delta_latitude = p1.latitude - p2.latitude;
    let delta_longitude = p1.longitude - p2.longitude;
    let sin_half_delta_latitude = f64::sin(delta_latitude * 0.5);
    let sin_half_delta_longitude = f64::sin(delta_longitude * 0.5);

    let a = sin_half_delta_latitude * sin_half_delta_latitude
        + f64::cos(p1.latitude)
            * f64::cos(p2.latitude)
            * sin_half_delta_longitude
            * sin_half_delta_longitude;
    let c = 2. * f64::atan2(f64::sqrt(a), f64::sqrt(1. - a));

    EARTH_RADIUS_KM * c
}

fn read_cities(filename: &str) -> MyError<HashMap<String, Point>> {
    let mut rdr = csv::Reader::from_path(filename)?;
    let mut cities = HashMap::<String, Point>::new();

    for result in rdr.records() {
        let record = result?;

        let read_field = |i| record.get(i).ok_or(record.as_slice());
        let read_coordinate_field =
            |i| -> MyError<f64> { Ok(read_field(i)?.parse::<f64>()?.to_radians()) };

        let name = read_field(1)?;
        let country = read_field(5)?;
        let latitude = read_coordinate_field(2)?;
        let longitude = read_coordinate_field(3)?;

        cities.insert(
            format!("{}, {}", name, country),
            Point {
                latitude,
                longitude,
            },
        );
    }
    Ok(cities)
}

fn main() -> MyError<()> {
    let path = "/Users/daniel.balchev/personal/all-the-things/resources/datafiles/world-cities.csv";

    let city_1 = "Karlovo, BG";
    let city_2 = "Mumbai, IN";
    let cities = read_cities(path)?;

    let city_1_location = cities.get(city_1).ok_or(format!("{} is missing", city_1))?;
    let city_2_location = cities.get(city_2).ok_or(format!("{} is missing", city_2))?;
    let inter_city_distance = distance(city_1_location, city_2_location);
    println!(
        "{:?} {:?} {}",
        city_1_location, city_2_location, inter_city_distance
    );

    let mut api_key = String::new();
    File::open(".apikey")?.read_to_string(&mut api_key)?;

    let client = reqwest::blocking::Client::new();
    let url = format!("https://maps.googleapis.com/maps/api/distancematrix/json?destinations=New%20York%20City%2C%20NY&origins=Washington%2C%20DC&units=metric&key={}", api_key);
    let res = client.get(url).send()?.text()?;

    let res = serde_json::from_str::<Value>(&res)?;

    println!("{}", res);

    let a = res["rows"][0]
        // .as_array().unwrap()[0]["elements"].as_array().unwrap()[0]
        .clone();

    println!("{}", a);

    Ok(())
}
