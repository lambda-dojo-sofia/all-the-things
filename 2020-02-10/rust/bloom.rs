// This is a comment, and is ignored by the compiler
// You can test this code by clicking the "Run" button over there ->
// or if you prefer to use your keyboard, you can use the "Ctrl + Enter" shortcut

// This code is editable, feel free to hack it!
// You can always return to the original code by clicking the "Reset" button ->

// This is the main function

use std::fs;

fn create_bloom_filter <'a> (size:u32) -> &'a mut Vec<bool> {
    let &mut filter:Vec<bool> = Vec::with_capacity(size as usize);

    for i in 0..size {
        filter.push(false);
    }
    return filter;
}

fn main() {
    // Statements here are executed when the compiled binary is called

    //let contents = fs::read_to_string("../input").unwrap();
    let contents = std::io::stdin().lock();

    let io = contents.lines();
    let mut input: Vec<&str> = vec![];
    let mut test: Vec<&str> = vec![];
    let mut operation = false;

    for line in io {
        if line == "" {
            operation = true;
            continue;
        }

        if operation == false {
            input.push(line)
        } else {
            test.push(line)
        }
    }

    println!("The input is:\n{:?}", input);
    println!("The test cases are:\n{:?}", test);
}


// ls poop.rs | entr -cr bash -c 'rustc bloom.rs && ./bloom'
