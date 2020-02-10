use std::io::stdin;
use std::io::prelude::*;
use std::string::String;
use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};

const N_HASHES : u64 = 3;

fn main() {
    let mut query = false;
    let mut filter = 0;

    for line in stdin().lock().lines() {
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

fn add_val(filter : u64, val : String) -> u64 {
    filter | hash(val)
}

fn find_val(filter : u64, val : String) -> bool {
    let h = hash(val);
    filter & h == h
}

fn hash(val : String) -> u64 {
    let mut r = 0;
    for i in 0..N_HASHES {
        r = bit_idx(i, val.clone());
    };
    r
}

fn bit_idx(salt : u64, val : String) -> u64 {
    let mut hasher = DefaultHasher::new();
    salt.hash(&mut hasher);
    val.hash(&mut hasher);
    1 << (hasher.finish() % 64)
}
