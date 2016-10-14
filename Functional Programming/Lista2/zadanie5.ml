let rec map f xs =
  match xs with
    [] -> []
  |hd::tl -> (f hd) :: (map f tl);;

let rec concatMap f xs =
  match xs with
    [] -> []
  |hd::tl -> (f hd) @ (concatMap f tl);;

let rev x = 
  let rec aux acc x = 
    match x with
      [] -> acc
    |hd::tl -> aux (hd::acc) tl
  in aux [] x;;

let selectDeleteAll x = 
  let rec aux resultsAcc revList x =
    match x with
      [] -> resultsAcc
    |hd::tl -> aux ((hd,((rev revList) @ tl))::resultsAcc) (hd::revList) tl
  in aux [] [] x;;   

let rec perm xs =
  if xs = []
  then [[]]
  else
    let aux (y,ys) =
      let perms = perm ys
      in map (fun zs -> y::zs) perms
    in concatMap aux (selectDeleteAll xs);;

(*TEST*)
perm [1;2;3;4];;
List.length (perm [1;2;3;4;5;6;7;8;9]);;