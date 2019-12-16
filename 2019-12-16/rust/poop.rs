//Part one kind of done....?
//

fn at_least_two(n: u32, current_digit: u32) -> bool {
    if n < 10 {
        return current_digit == n
    }
    let last_digit = n % 10;
    return current_digit == last_digit || at_least_two(n / 10, last_digit)
}

fn decreasing(n: u32, current_digit: u32) -> bool {
    if n < 10 {
        return current_digit >= n
    }
    let last_digit = n % 10;
    return current_digit >= last_digit || decreasing(n / 10, last_digit)
}


fn main() {
    // Statements here are executed when the compiled binary is called
    let input = "235741-706948".split("-");
    let range:  Vec<&str> = input.collect();

    let start :u32 = range[0].parse().unwrap();
    let end :u32 = range[1].parse().unwrap();

    let whole_range = start..end;

    println!("Valid numbers: {}", whole_range.filter(|n| at_least_two(*n, 11) && decreasing(*n, 0)).collect::<Vec<u32>>().len());
}
