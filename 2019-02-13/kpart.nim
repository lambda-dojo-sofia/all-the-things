import parseutils
import sequtils

func sum(xs: seq[int]): int =
    var s: int
    for x in xs:
        s += x
    return s

func partitionz(xs: seq[int], t: int, keep: seq[int], drop: seq[int]): (seq[int], seq[int]) =
    if t == 0:
        return (keep, concat(drop, xs))
    if len(xs) == 0 or t < 0:
        return (@[], @[])
    var n = xs[0]
    var xss = xs[1..len(xs)-1]
    var (k, d) = partitionz(xss, t - n, keep & n, drop)
    if len(k) != 0:
        return (k, d)
    return partitionz(xss, t, keep, drop & n)

func partition(xs: seq[int], t: int, acc: seq[seq[int]]): seq[seq[int]] =
    if len(xs) == 0:
        return acc
    var (k, d) = partitionz(xs, t, @[], @[])
    if len(k) == 0:
        return @[]
    return partition(d, t, acc & k)

proc main() =
    var xs: seq[int]

    xs = @[]

    var n: int
    for line in stdin.lines:
        discard parseInt(line.string, n)
        xs = xs & n

    var p = 3

    if sum(xs) %% p != 0:
        echo("no u wont")
        return

    var t = sum(xs) /% p

    var partitions = partition(xs, t, @[]) 
    echo(partitions)

main()
