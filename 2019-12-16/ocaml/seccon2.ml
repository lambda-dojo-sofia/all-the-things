open Seccon

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

let valid n = valid n && exactly_two_adj_digits n
