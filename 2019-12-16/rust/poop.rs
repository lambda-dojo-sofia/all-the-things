//Part one kind of done....?
//

fn at_least_two(n: u32, current_digit: u32) -> bool {
    if n < 10 {
        return current_digit == n
    }
    let last_digit = n % 10;
    return current_digit == last_digit || at_least_two(n / 10, last_digit)
}

fn exactly_two(n: u32, current_digit: u32, count: &mut u32) -> bool {

    if n < 10 {
        if current_digit == n {
            *count += 1;
        }
        return *count == 2;
    }

    let last_digit = n % 10;
    if current_digit != last_digit && *count == 2 {
        return true;
    }

    if current_digit == last_digit {
        *count += 1;
    } else {
        *count = 1;
    }
    return exactly_two(n / 10, last_digit, count);
}


fn decreasing(n: u32, current_digit: u32) -> bool {
    if n < 10 {
        return current_digit >= n
    }

    let last_digit = n % 10;
    return current_digit >= last_digit && decreasing(n / 10, last_digit)
}

fn main() {
    // Statements here are executed when the compiled binary is called
    let input = "235741-706948".split("-");
    let range:  Vec<&str> = input.collect();

    let start :u32 = range[0].parse().unwrap();
    let end :u32 = range[1].parse().unwrap();

    let whole_range = start..end;
    let whole_range2 = start..end;

    let mut real_count: u32 = 1;
    let count: &mut u32 = &mut real_count;

    println!("Valid numbers 1: {}", whole_range.filter(|n| at_least_two(*n, 11) && decreasing(*n, 10)).collect::<Vec<u32>>().len());
    println!("Valid numbers 2: {}", whole_range2.filter(|n| exactly_two(*n / 10, *n % 10, count) && decreasing(*n, 10)).collect::<Vec<u32>>().len());
}
