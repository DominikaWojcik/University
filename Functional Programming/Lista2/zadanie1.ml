let rec prependWith x a b =
  match a with
    [] -> b
  |hd::tl -> (x::hd) :: prependWith x tl b;;

let rec podciagi x =
  match x with
    [] -> [[]]
  |hd::tl -> let pod = podciagi tl in
    prependWith hd pod pod;;

podciagi [1;2;3;4;5];;