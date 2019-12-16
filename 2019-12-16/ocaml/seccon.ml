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

let rec count_valid' acc valid lo hi =
    if lo > hi then acc else
    count_valid' (if valid lo then acc + 1 else acc) valid (lo+1) hi

let count_valid = count_valid' 0

let rec count_adj' acc n =
    if n < 10 then acc else
    if last n = last_but_one n then count_adj' (acc+1) (chop_last n)
    else acc

let count_adj = count_adj' 1

let rec chop_last_n c n =
    if c < 1 then n
    else chop_last_n (c-1) (chop_last n)

let rec exactly_two_adj_digits n =
    if n < 10 then false else
    if count_adj n = 2 then true
    else exactly_two_adj_digits (chop_last_n (count_adj n) n)

let valid2 n = valid n && exactly_two_adj_digits n

let run valid = Format.printf "%d\n"
    (count_valid valid (int_of_string Sys.argv.(1)) (int_of_string Sys.argv.(2)))
