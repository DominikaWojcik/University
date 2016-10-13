let rev x = 
  let rec aux acc x = 
    match x with
      [] -> acc
    |hd::tl -> aux (hd::acc) tl
  in aux [] x;;

let split x n = 
  let rec aux acc x n= 
    if n = 0
    then rev acc, x
    else let hd::tl = x in
      aux (hd::acc) tl (n-1)
  in aux [] x n;;

let cycle x n = 
  let ft,sd = split (rev x) n in
  rev ft @ rev sd;;