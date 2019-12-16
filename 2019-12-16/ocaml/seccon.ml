let in_range (lo:int) hi n = n >= lo && n <= hi

let six_digits (n:int) = in_range 100000 999999 n

let last_but_one n = ((n / 10) mod 10)

let last n = n mod 10

let chop_last n = n / 10

let rec two_adj_digits n =
    if n < 10 then false else
    if last n = last_but_one n then true else
    two_adj_digits (chop_last n)

let rec increasing_digits n =
    if n < 10 then true else
    if last n < last_but_one n then false else
    increasing_digits (chop_last n)

let valid n =
    six_digits n
    && two_adj_digits n
    && increasing_digits n

let rec count_valid' acc lo hi =
    if lo > hi then acc else
    count_valid' (if valid lo then acc + 1 else acc) (lo+1) hi

let count_valid = count_valid' 0

let () = Format.printf "%d\n"
    (count_valid (int_of_string Sys.argv.(1)) (int_of_string Sys.argv.(2)))
