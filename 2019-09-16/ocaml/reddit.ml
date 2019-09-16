#use "topfind";;
#require "csv";;

type post =
    { title : string ;
      karma : int };;

let csvOfSubreddit subreddit = "../reddit-top-2.5-million-master/data/" ^ subreddit ^ ".csv";;

let rec zip lft rgt =
    match lft, rgt with
    | l :: lr, r :: rr -> (l, r) :: zip lr rr
    | _, _ -> [];;

let rec field name fields =
    match fields with
    | (n, v) :: _ when n = name -> v
    | _ :: rest -> field name rest
    | [] -> "";;

let intField name fields =
    match int_of_string_opt (field name fields) with
    | Some i -> i
    | _ -> 0;;

let postOfCsvRow header row =
    let fields = zip header row in
    { title = (field "title" fields) ;
      karma = (intField "score" fields) };;

let postsOfCsvRows csvRows =
    match csvRows with
    | [] -> []
    | header :: postRows -> List.map (postOfCsvRow header) postRows;;

let postsOfSubreddit subreddit =
    let rows = Csv.load (csvOfSubreddit subreddit) in
    postsOfCsvRows rows;;

let rec incKarma acc word karma =
    match acc with
    | (w, k) :: rest when word = w -> (w, k + karma) :: rest
    | o :: rest -> o :: incKarma rest word karma
    | [] -> [(word, karma)];;

let rec scoreTitle acc karma words =
    match words with
    | word :: rest -> scoreTitle (incKarma acc word karma) karma rest
    | [] -> acc;;

let words = String.split_on_char ' ';;

let rec mostKarmicWordsOfPosts acc posts =
    match posts with
    | post :: rest -> mostKarmicWordsOfPosts (scoreTitle acc post.karma (words post.title)) rest
    | [] -> acc;;

let rec take n l =
    if n <= 0 then [] else match l with
    | x :: rest -> x :: (take (n - 1) rest)
    | [] -> [];;

let stopwords = [
    "in";
    "the";
    "a";
    "to";
    "at";
    "i";
    "and";
    "of";
    "is";
    "from";
    "this";
    "for";
    "my";
    "his";
    "her";
    "was";
    "on";
    "with";
    "he";
    "she";
    "me";
    "when";
    "like";
    "new";
    "that";
];;

let isStopword word = List.exists (fun w -> w = String.lowercase_ascii word) stopwords;;

let main =
    let subreddit = "aww" in
    let posts = postsOfSubreddit subreddit in
    let words = mostKarmicWordsOfPosts [] posts in
    let words = List.sort (fun (_, k) (_, j) -> compare j k) words in
    let words = List.filter (fun (w, _) -> not (isStopword w)) words in
    let words = take 5 words in
    List.map (fun (w, k) -> Printf.printf "% 8d %s\n" k w) words
