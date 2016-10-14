let rev x = 
  let rec aux acc x = 
    match x with
      [] -> acc
    |hd::tl -> aux (hd::acc) tl
  in aux [] x;;

let len x = 
  let rec aux acc x =
    match x with
      [] -> acc
    |_::tl -> aux (acc+1) tl
  in aux 0 x;;

let split x n = 
  let rec aux acc x n= 
    if n = 0 || x = []
    then acc, x
    else let hd::tl = x in
      aux (hd::acc) tl (n-1)
  in aux [] x n;;

(********************************************************)

let rec merge cmp a b = 
  match a,b with
    [],_ -> b
  |_,[] -> a
  |hda::tla, hdb::tlb -> 
    if cmp hda hdb 
    then hda :: merge cmp tla b
    else hdb :: merge cmp a tlb;;

let merge2 cmp a b = 
  let rec aux cmp a b acc =
    match a,b with
      [],[] -> acc
    |hda::tla, [] -> aux cmp tla b (hda::acc)
    |[], hdb::tlb -> aux cmp a tlb (hdb::acc)
    |hda::tla, hdb::tlb -> 
      if cmp hda hdb 
      then aux cmp tla b (hda::acc)
      else aux cmp a tlb (hdb::acc)
  in rev (aux cmp a b []);;

let rec mergesort cmp a =
  let length = len a in 
  if length < 2
  then a
  else
    let xs,ys = split a (length/2) in
    let sortedxs = mergesort cmp xs
    and sortedys = mergesort cmp ys
    in merge cmp sortedxs sortedys;;

(*****************************************************************)
let splitNoRev x n = 
  let rec aux acc x n= 
    if n = 0 || x = []
    then acc, x
    else let hd::tl = x in
      aux (hd::acc) tl (n-1)
  in aux [] x n;;

let mergeNoRev cmp a b = 
  let rec aux cmp a b acc =
    match a,b with
      [],[] -> acc
    |hda::tla, [] -> aux cmp tla b (hda::acc)
    |[], hdb::tlb -> aux cmp a tlb (hdb::acc)
    |hda::tla, hdb::tlb -> 
      if cmp hda hdb 
      then aux cmp tla b (hda::acc)
      else aux cmp a tlb (hdb::acc)
  in aux cmp a b [];;  

let rec mergesort2 cmp a =
  let length = len a in 
  if length < 2
  then a
  else
    let xs,ys = splitNoRev a (length/2) 
    and revCmp x y = not (cmp x y) in
    let sortedxs = mergesort2 revCmp xs
    and sortedys = mergesort2 revCmp ys
    in mergeNoRev revCmp sortedxs sortedys;;


merge (<=) [1;2;5] [3;4;5];;
merge2 (<=) [1;2;5] [3;4;5];;
mergesort (<=) [2;5;2;7;9;5;3;6;9;0;5;2;2;5;6;5;-1;43;3;-133];;
mergesort2 (<=) [2;5;2;7;9;5;3;6;9;0;5;2;2;5;6;5;-1;43;3;-133];;

let rec ones acc n = 
  if n = 0
  then acc
  else ones (1::acc) (n-1);;

let toSort = ones [] 1000000;;

mergesort (<=) toSort;;
mergesort2 (<=) toSort;;