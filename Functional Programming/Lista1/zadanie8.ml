let zlozenie f g = (fun x -> f(g x));;

let rec iter f ile =
  if ile > 1
  then 
    (fun x -> x)
  else
    zlozenie f (iter f (ile - 1))
;;

let mul a b = (iter ((+) a) b) 0;;
let ( ** ) a b = (iter (( * ) a) b) 1;;

(* TESTY *)

mul 4 5;;
2 ** 16;;
