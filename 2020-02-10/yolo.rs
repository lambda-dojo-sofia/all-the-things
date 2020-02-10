use std::io;
use std::io::prelude::*;
use std::string;
use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};

fn main() {
    let stdin = io::stdin();
    let mut query = false;
    let mut filter = 0;

    for line in stdin.lock().lines() {
        let val = line.unwrap();

        if val == "" {
            query = true;
        } else if ! query {
            filter = add_val(filter, val);
        } else {
            if find_val(filter, val.clone()) {
                println!("I might have seen {}", val)
            } else {
                println!("I definitely didn't see {}", val)
            }
        }
    }
}

fn add_val(filter : u64, val : string::String) -> u64 {
    println!("{}", hash(val.clone()));
    filter | hash(val)
}

fn find_val(filter : u64, val : string::String) -> bool {
    let h = hash(val);
    filter & h == h
}

fn hash(val : string::String) -> u64 {
    bit_idx(1, val.clone()) |
    bit_idx(2, val.clone()) |
    bit_idx(3, val.clone())
}

fn bit_idx(salt : i64, val : string::String) -> u64 {
    let mut hasher = DefaultHasher::new();
    salt.hash(&mut hasher);
    val.hash(&mut hasher);
    1 << (hasher.finish() % 64)
}
